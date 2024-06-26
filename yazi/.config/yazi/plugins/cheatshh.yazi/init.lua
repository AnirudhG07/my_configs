local state = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function fail(s, ...)
	ya.notify({ title = "YaziCheatshh", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function entry(_, args)
	local _permit = ya.hide()
	local cwd = state()
	local shell_value = os.getenv("SHELL"):match(".*/(.*)")
	local cmd_args = ""
	if args[1] == nil then
		cmd_args = [[cheatshh]]
		-- All the flags are -a, -g, -ec, -eg, -dc, -dg, -m, simply we have to run cheatshh -flag.
	end
	local child, err = Command(shell_value)
		:args({ "-c", cmd_args })
		:cwd(cwd)
		:stdin(Command.INHERIT)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		return fail("Spawn `cheatshh` failed with error code %s. Do you have it installed?", err)
	end

	local output, err = child:wait_with_output()
	if not output then
		return fail("Cannot read `cheatshh` output, error code %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`cheatshh` exited with error code %s", output.status.code)
	end
end

return { entry = entry }
