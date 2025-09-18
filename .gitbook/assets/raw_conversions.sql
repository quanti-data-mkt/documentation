-- Extraction des conversion_id et des informations liées au hit de la conversion
with raw_conversions AS (
    SELECT
        *
    FROM
        `printemps-quanti`.`web_tag_v2`.`raw_hits` A
    WHERE 
        conversion_id <> "" # Exclusion des conversions_id avec une valeur vide
        AND conversion_id <> "undefined" # Exclusion des conversions_id = à undefined
        AND conversion_id IS NOT NULL # Exclusion des hits qui ne sont pas des conversions
   # NB : il peut y avoir plusieurs conversions par session.
   qualify row_number() over(partition by conversion_id,session_id order by datetime desc) = 1
   # On crée l'unicité du conversion_id par session
  )

/* Règles d'attribution finale */

    #1 Rattrapage des sessions par le visitor_id
      -- On rattache toutes les sessions enregistrant le même visitor_id que celui du hit de la conversion_id
      -- OFF : Nous excluons les sessions du visitor_id qui n'aurait pas le même user_id que le hit de la conversion
    #2 Rattrapage des sessions par le user_id
      -- On rattache toutes les sessions enregistrant le même user_id que celui du hit de la conversion_id         
      -- On s'assure que le visitor_id est différent de celui de la conversion car déjà rattaché par l'étape #1

#1 Rattrapage des sessions par le visitor_id
, attrib_temporaire_1 AS (
    select 
        C.conversion_id as c_conversion_id,
        C.hit_id as hit_id,
        S.session_id as s_session_id,
        C.conversion_type as c_conversion_type,
        C.conversion_value as c_conversion_value,
        DATE(C.datetime) as c_date,
        C.datetime as c_datetime,
        S.datetime as s_datetime,
        C.user_id as c_user_id,
        S.s_source,
        S.s_medium,
        S.s_campaign,
        S.s_content,
        S.s_consent,
        S.s_keyword,
        S.s_utmid,
        S.s_referrer,
        C.visitor_id as s_visitor_id
    FROM
        raw_conversions C
-- On rattache toutes les sessions enregistrant le même visitor_id que celui du hit de la conversion_id
    LEFT JOIN
        `printemps-quanti`.`web_tag_v2`.`raw_sessions` S ON C.visitor_id = S.visitor_id  
    WHERE 
        TRUE
-- On fiabilise notre requete en s'assurant que le visitor_id de la conversion est le même que celui de la session
        AND (C.visitor_id = S.visitor_id) 
-- Nous excluons les sessions du visitor_id qui n'aurait pas le même user_id que le hit de la conversion
        # OFF : AND concat(C.visitor_id,ifnull(C.user_id,'')) = concat(S.visitor_id,ifnull(S.user_id,''))
-- Nous rattachons uniquement les sessions anterieures à la date de conversion
        AND C.datetime >= S.datetime
    GROUP BY
        1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
)

#2 Rattrapage des sessions par le user_id
, attrib_temporaire_2 AS (
    SELECT
        C.conversion_id as c_conversion_id,
        C.hit_id as hit_id,
        S.session_id as s_session_id,
        C.conversion_type as c_conversion_type,
        C.conversion_value as c_conversion_value,
        DATE(C.datetime) as c_date,
        C.datetime as c_datetime,
        S.datetime as s_datetime,
        C.user_id as c_user_id,
        S.s_source,
        S.s_medium,
        S.s_campaign,
        S.s_content,
        S.s_consent,
        S.s_keyword,
        S.s_utmid,
        S.s_referrer,
        S.visitor_id as s_visitor_id
    FROM
        raw_conversions C
-- On rattache toutes les sessions enregistrant le même user_id que celui du hit de la conversion_id 
    LEFT JOIN (
        select 
          *
        from
          `printemps-quanti`.`web_tag_v2`.`raw_sessions` 
        where 
          user_id <> "" AND user_id <> "undefined" AND user_id IS NOT NULL
    ) S ON C.user_id = S.user_id
    WHERE
        TRUE
-- On s'assure que le visitor_id est différent de celui de la conversion car déjà rattaché par l'étape #1
        AND S.visitor_id <> C.visitor_id
-- On s'assure que les sessions ne sont pas déjà rattrachées à la conversion par l'étape #1
        AND concat(S.session_id,C.conversion_id,hit_id) NOT IN (SELECT concat(s_session_id,c_conversion_id,hit_id) FROM attrib_temporaire_1)
-- Nous rattachons uniquement les sessions anterieures à la date de conversion
        AND C.datetime >= S.datetime
    GROUP BY
        1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
)

, attrib_temporaire_3_bis AS (
  SELECT * FROM attrib_temporaire_1
  UNION ALL
  SELECT * FROM attrib_temporaire_2
)

-- identification de la session last clic
, attrib_temporaire_3 as ( 
    select
        A.*,
        case when A.s_session_id = B.session_id then 1 else 0 end as last_clic
    from attrib_temporaire_3_bis A
    left join raw_conversions B on A.s_session_id = B.session_id and A.hit_id = B.hit_id
)

-- Création du path_index
, tab_with_index_path as (
    SELECT 
        A.* except(last_clic),
        ROW_NUMBER() OVER (PARTITION BY A.hit_id ORDER BY A.s_datetime,last_clic ASC) as path_index
    FROM 
        attrib_temporaire_3 A
    
)

, tab_with_max_index as (
    SELECT 
        *,
        max(path_index) over (partition by hit_id) as max_index
    FROM 
        tab_with_index_path
)

-- En fonction de la date du résultats, on vient définir les modèle d'attrib adéquats
SELECT 
    A.*,
    timestamp_diff(c_date, date(s_datetime), day) as lookback_window,
    -- Si max_path = path_index alors il s'agit de la derniere session
    case 
        when max_index = path_index 
        then true else false 
    end as is_last_clic,

    # Nouveau LDNC
    case
        when # 1. Si la derniere session de la conversion a un source_medium différent de direct/none alors il s'agit de la LCND
            max_index = path_index 
            and A.s_source != "(direct)" and A.s_medium != "(none)"
        then true
        when # 2. Si la SEULE session de la conversion a un source_medium=direct/none alors elle est LCND
            max_index = 1 and path_index = 1
            and A.s_source = "(direct)" and A.s_medium = "(none)"
        then true
        when # 3. Si la derniere session (et celles qui la précède quelque soit leur nombre) ont un source_medium=direct/none alors le LCND est la session la plus proche de la conversion enregistrant un source_medium différent de direct/none
            A.s_session_id = C.max_session_id
        then true
        when #4 Si toutes les sessions menant à la conversion ont pour source_medium=direct/none alors c'est la session la plus récent qui est LCND
            A.hit_id = D.hit_id
            and max_index = D.direct_count
            and path_index = D.direct_count
        then true 
        else false
    end as is_last_clic_non_direct,
    CASE WHEN timestamp_diff(c_date, date(s_datetime), day) <= 30 then TRUE ELSE FALSE END as is_post_clic_30,
    CASE WHEN timestamp_diff(c_date, date(s_datetime), day) <= 60 then TRUE ELSE FALSE END as  is_post_clic_60,
    CASE WHEN timestamp_diff(c_date, date(s_datetime), day) <= 90 then TRUE ELSE FALSE END as  is_post_clic_90,
    CASE WHEN timestamp_diff(c_date, date(s_datetime), day) <= 120 then TRUE ELSE FALSE END as  is_post_clic_120,
    CASE WHEN timestamp_diff(c_date, date(s_datetime), day) <= 180 then TRUE ELSE FALSE END as  is_post_clic_180,
    CASE WHEN path_index = 1 and timestamp_diff(c_date, date(s_datetime), day) <= 30 then TRUE ELSE FALSE END as is_first_clic_30,
    CASE WHEN path_index = 1 and timestamp_diff(c_date, date(s_datetime), day) <= 60 then TRUE ELSE FALSE END as is_first_clic_60,
    CASE WHEN path_index = 1 and timestamp_diff(c_date, date(s_datetime), day) <= 90 then TRUE ELSE FALSE END as is_first_clic_90,
    CASE WHEN path_index = 1 and timestamp_diff(c_date, date(s_datetime), day) <= 120 then TRUE ELSE FALSE END as is_first_clic_120,
    CASE WHEN path_index = 1 and timestamp_diff(c_date, date(s_datetime), day) <= 180 then TRUE ELSE FALSE END as is_first_clic_180
FROM tab_with_max_index A
left join # pour récupérer les max_session en excluant les source_medium=direct/none
    (
        select
            hit_id,
            s_session_id as max_session_id
        from tab_with_max_index
        where s_source != "(direct)" and s_medium != "(none)"
        QUALIFY ROW_NUMBER() OVER (PARTITION BY hit_id ORDER BY path_index DESC) = 1
    ) C
on A.s_session_id = C.max_session_id and A.hit_id = C.hit_id
left join # pour récupérer le nombre de sessions où source_medium=direct/none par conversion
    (
        select
            hit_id,
            sum(case when s_source = "(direct)" and s_medium = "(none)" then 1 else 0 end) as direct_count
        from tab_with_max_index
        group by 1
    ) D on D.hit_id = A.hit_id