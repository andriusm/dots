local M = {}

local MOUNT_SCRIPT = [[
p=$PPID
if [ "$1" = macos ]; then
	rclone nfsmount ":archive:$2" "$3" --read-only >/dev/null 2>&1 &
else
	rclone mount ":archive:$2" "$3" --read-only >/dev/null 2>&1 &
fi
r=$!
echo $r
(while kill -0 $p 2>/dev/null && kill -0 $r 2>/dev/null; do sleep 2; done; kill $r 2>/dev/null) >/dev/null 2>&1 &
]]

local function base()
	local tmp = os.getenv("TMPDIR") or "/tmp/"
	if tmp:sub(-1) ~= "/" then
		tmp = tmp .. "/"
	end
	return tmp .. "yazi-zip"
end

local function under(path, dir) return path == dir or path:sub(1, #dir + 1) == dir .. "/" end

local hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and { url = tostring(h.url), is_dir = h.cha.is_dir }
end)

local set_active = ya.sync(function(st, active) st.active = active end)

local function is_mounted(mnt)
	local out = Command("mount"):stdout(Command.PIPED):output()
	if not out then
		return false
	end
	return out.stdout:find(" on " .. mnt .. " ", 1, true) ~= nil
		or out.stdout:find(" on /private" .. mnt .. " ", 1, true) ~= nil
end

local function mount(zip)
	local mnt = base() .. zip
	Command("mkdir"):arg({ "-p", mnt }):status()

	local out, err = Command("sh")
		:arg({ "-c", MOUNT_SCRIPT, "sh", ya.target_os(), zip, mnt })
		:stdout(Command.PIPED)
		:output()
	if not out then
		return nil, tostring(err)
	end
	local pid = out.stdout:match("%d+")

	for _ = 1, 50 do
		if is_mounted(mnt) then
			return mnt, pid
		end
		ya.sleep(0.1)
	end
	if pid then
		Command("kill"):arg({ pid }):status()
	end
	return nil, "rclone did not mount the archive"
end

function M:setup()
	ps.sub("cd", function()
		local a = self.active
		if not a then
			return
		end

		local cwd = tostring(cx.active.current.cwd)
		if under(cwd, a.mnt) then
			return
		end

		self.active = nil
		if under(cwd, base()) then
			ya.emit("reveal", { Url(a.zip) })
		end
		ya.emit("plugin", { "zip-mount", "unmount " .. a.pid })
	end)
end

function M:entry(job)
	if job.args[1] == "unmount" then
		return Command("kill"):arg({ tostring(job.args[2]) }):status()
	end

	local h = hovered()
	if not h or h.is_dir or not h.url:lower():match("%.zip$") then
		return ya.emit("enter", {})
	end
	if under(h.url, base()) then
		return ya.notify { title = "zip-mount", content = "Nested zip files are not supported", timeout = 3, level = "warn" }
	end

	local mnt, pid = mount(h.url)
	if not mnt then
		return ya.notify { title = "zip-mount", content = pid, timeout = 5, level = "error" }
	end

	set_active { zip = h.url, mnt = mnt, pid = pid }
	ya.emit("cd", { Url(mnt) })
end

return M
