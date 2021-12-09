pythonx << EOF
def CompleteJupyter(findstart, base):
	if int(findstart)==1:
		try: _jupyter_session  # _jupyter_session is only available if jupyter-vim plugin is loaded and :JupyterConnect is executed at least once before
		except NameError: return -3

		if not _jupyter_session.kernel_client.check_connection_or_warn():
			# not connected
			return -3

		kc = _jupyter_session.kernel_client.km_client
		complete = kc.complete if hasattr(kc, 'complete') else kc.shell_channel.complete  # taken from vim-ipython plugin. The former is newer API

		line=vim.Function("getline")(".").decode('u8')
		col=vim.Function("charcol")(".")-1
		assert 0<=col<=len(line), (col, len(line))
		assert CompleteJupyter.result is None
		try:
			CompleteJupyter.result=complete(
					code=line, cursor_pos=col,
					reply=True, timeout=2)
		except TimeoutError:
			# should not happen, checked just above, but just in case...
			return -3

		return CompleteJupyter.result["content"]["cursor_start"]

	else:
		assert int(findstart)==0, findstart

		initial_len: int=CompleteJupyter.result["content"]["cursor_end"]-CompleteJupyter.result["content"]["cursor_start"]
		assert initial_len>=0, initial_len

		if CompleteJupyter.result["content"]["matches"]:
			assert base==CompleteJupyter.result["content"]["matches"][0][:initial_len], (base, CompleteJupyter.result["content"]["matches"][0][:initial_len])

		result=CompleteJupyter.result["content"]["matches"]
		CompleteJupyter.result=None
		return result

CompleteJupyter.result=None
EOF

function! CompleteJupyter(findstart, base)
	pythonx vim.bindeval("s:")["complete_result"]=CompleteJupyter(vim.eval("a:findstart"), vim.eval("a:base"))
	return s:complete_result
endfunction


setlocal omnifunc=CompleteJupyter

