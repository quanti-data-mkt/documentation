#!/usr/bin/env python3
"""Build the connector catalog pages from reference/connectors.json.

The list is the single source of truth: one entry per connector card, with the
category pages ("filters") that show it. A connector can be in several filters.

This script rewrites, and only rewrites:
  - the "All connectors" page (connect/connectors.md)
  - one page per filter (Marketing, Sales, Analytics, Custom, Market Insights)

Do not edit those pages by hand, in Git or in GitBook: edit the list, then run

    python3 scripts/build_connector_pages.py          # rewrite the pages
    python3 scripts/build_connector_pages.py --check  # exit 1 if a page is out of date

Never rename or move a published .md file: its URL and the in-app help
(reference/help-map.json) depend on it. Change titles in SUMMARY.md instead.
"""
import html
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIST = os.path.join(ROOT, 'reference', 'connectors.json')


def rel(target, from_page):
    """Relative link from one page to another, as GitBook resolves it."""
    return os.path.relpath(target, os.path.dirname(from_page) or '.').replace(os.sep, '/')


def card_table(rows, with_line):
    line_col = '<th></th>' if with_line else ''
    head = (f'<table data-view="cards"><thead><tr><th width="48"></th><th></th>{line_col}'
            '<th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody>')
    return head + ''.join(rows) + '</tbody></table>'


def card(entry, from_page, logo_url, second_line=None):
    name = html.escape(entry['name'])
    if logo_url and entry.get('sku'):
        icon = f'<img src="{logo_url.format(sku=entry["sku"])}" alt="" data-size="line">'
    else:
        icon = '<i class="fa-plug"></i>'
    line = '' if second_line is None else f'<td>{html.escape(second_line)}</td>'
    return (f'<tr><td>{icon}</td><td><strong>{name}</strong></td>{line}'
            f'<td><a href="{rel(entry["page"], from_page)}">{name}</a></td></tr>')


def page(description, title, intro, table):
    desc = description.replace("'", "''")
    return f"---\ndescription: '{desc}'\n---\n\n# {title}\n\n{intro}\n\n{table}\n"


def build(data):
    filters = {f['key']: f for f in data['filters']}
    logo_url = data.get('logo_url')
    entries = sorted(data['connectors'], key=lambda e: e['name'].lower())
    errors = []
    for e in entries:
        if not os.path.exists(os.path.join(ROOT, e['page'])):
            errors.append(f"{e['name']}: page not found ({e['page']})")
        for k in e.get('filters', []):
            if k not in filters:
                errors.append(f"{e['name']}: unknown filter '{k}'")
    if errors:
        sys.exit('reference/connectors.json has errors:\n  ' + '\n  '.join(errors))

    pages = {}
    allp = data['all_connectors']
    links = ' · '.join(f"[{f['title']}]({rel(f['page'], allp['page'])})" for f in data['filters'])
    rows = [card(e, allp['page'], logo_url,
                 e.get('label') or ' · '.join(filters[k]['title'] for k in e.get('filters', [])))
            for e in entries]
    pages[allp['page']] = page(allp['description'], allp['title'],
                               f'{len(entries)} connectors, from A to Z. Browse by category: {links}.',
                               card_table(rows, with_line=True))
    for f in data['filters']:
        members = [e for e in entries if f['key'] in e.get('filters', [])]
        rows = [card(e, f['page'], logo_url) for e in members]
        intro = (f"{len(members)} connectors. See every connector in "
                 f"[{allp['title']}]({rel(allp['page'], f['page'])}).")
        pages[f['page']] = page(f['description'], f['title'], intro, card_table(rows, with_line=False))
    return pages


def hidden(page):
    """True when the page's frontmatter hides it from the menu."""
    text = open(os.path.join(ROOT, page), encoding='utf-8').read()
    front = text.split('---')[1] if text.startswith('---') else ''
    return re.search(r'^hidden:\s*true\s*$', front, re.M) is not None


def missing_from_list(data):
    """Connector pages listed in SUMMARY.md under All connectors but absent from the list."""
    summary = open(os.path.join(ROOT, 'SUMMARY.md'), encoding='utf-8').read().splitlines()
    listed = {e['page'] for e in data['connectors']}
    out, inside = [], False
    for line in summary:
        if f"]({data['all_connectors']['page']})" in line:
            inside, depth = True, len(line) - len(line.lstrip())
            continue
        if inside:
            ind = len(line) - len(line.lstrip())
            if not line.strip() or ind <= depth:
                break
            m = re.search(r'\]\(([^)\s]+\.md)', line)
            if m and ind == depth + 2 and m.group(1) not in listed and not hidden(m.group(1)):
                out.append(m.group(1))
    return out


def main():
    data = json.load(open(LIST, encoding='utf-8'))
    pages = build(data)
    stale = []
    for path, text in pages.items():
        full = os.path.join(ROOT, path)
        current = open(full, encoding='utf-8').read() if os.path.exists(full) else None
        if current != text:
            stale.append(path)
            if '--check' not in sys.argv:
                os.makedirs(os.path.dirname(full), exist_ok=True)
                open(full, 'w', encoding='utf-8').write(text)
    missing = missing_from_list(data)
    for p in missing:
        print(f'warning: {p} is under All connectors in SUMMARY.md but not in reference/connectors.json')
    if '--check' in sys.argv:
        if stale:
            sys.exit('Out of date, run scripts/build_connector_pages.py: ' + ', '.join(stale))
        print('Connector pages are up to date.')
    else:
        print(f"{len(stale)} page(s) rewritten, {len(pages) - len(stale)} unchanged.")


if __name__ == '__main__':
    main()
