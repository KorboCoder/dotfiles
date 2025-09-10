alias fhistory="history | fzf"
alias preview="fzf --preview 'bat --color \"always\" {}'"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort' \
--color=spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
# --color=bg+:#363a4f,bg:#24273a \
#
#custom choose foreground job
function fg_fzf (){
	# List jobs with their status and command, select one with fzf, then foreground it
	job_list=$(jobs -l)
	if [ -z "$job_list" ]; then
		echo "No jobs found."
		return 1;
	fi

	# Count the number of jobs
	job_count=$(echo "$job_list" | wc -l)

	if [ "$job_count" -eq 1 ]; then
		# Automatically select the single job
		job_id=$(echo "$job_list" | awk '{print $1}' | sed 's/\]//g' | sed 's/\[//g')
	else

	  # Use fzf to select a job if there are multiple jobs
	  selected_job=$(echo "$job_list" | fzf)
	  if [ -n "$selected_job" ]; then
		  job_id=$(echo "$selected_job" | awk '{print $1}' | sed 's/\]//g' | sed 's/\[//g')
	  else
		  echo "No job selected."
		  return 1;
	  fi
	fi

	# Bring the selected job to the foreground
	fg "%$job_id"
}
alias zf="fg_fzf"

gcha() {
  git checkout "$(git branch --all | fzf | tr -d '[:space:]')"
}
gch() {
  git checkout "$(git branch | fzf | tr -d '[:space:]')"
}
