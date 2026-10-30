#!/usr/bin/env bash
# TODO: remove when Gaurav-Gosain/tuios#1299 is fixed, then bind next_session/prev_session again
# Switch to the session delta rows away in the rail's grouped order; tuios 0.12.0 cycles the ungrouped list
set -euo pipefail
delta=$1
current=${TUIOS_SESSION:?}
state=${XDG_STATE_HOME:-$HOME/.local/state}/tuios/sidebar.json
group_main=$(tuios get-config appearance.sidebar.group_main 2>/dev/null || echo false)
# Without a daemon rank, the rail applies this client's drag order over the listing
order=$(jq -c '.order // []' "$state" 2>/dev/null || echo '[]')

target=$(tuios call list-sessions '{}' | jq -r \
  --argjson order "$order" --argjson group_main "$group_main" \
  --arg current "$current" --argjson delta "$delta" '
  def byrepo: . as $s | reduce $s[] as $n ({out: [], done: {}};
    if $n.repo == null then .out += [$n.name]
    elif .done[$n.repo] then .
    else .done[$n.repo] = true | .out += [$s[] | select(.repo == $n.repo) | .name] end) | .out;
  (.sessions // .)
  | (if any(.[]; (.rank // 0) > 0) then . else
      ($order | to_entries | map({(.value): .key}) | add // {}) as $rank
      | to_entries | sort_by([($rank[.value.name] // 1e9), .key]) | map(.value) end)
  | map(. + {repo: (if .worktree and ((.worktree.main // false) | not or $group_main)
                    then .worktree.repo else null end)})
  | ([.[] | select(.space and (.global | not))] | group_by(.space) | map(byrepo) | add // [])
    + ([.[] | select((.space and (.global | not)) | not)] | byrepo)
  | (to_entries | map(select(.value == $current)) | .[0].key) as $i
  | if $i == null or length < 2 then empty else .[($i + $delta) % length] end')

if [[ -n $target ]]; then
  exec tuios switch-session "$target" >/dev/null
fi
