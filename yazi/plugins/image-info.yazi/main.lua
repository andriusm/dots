local M = {}

local ICAT_MIMES = { jpeg = true, png = true, gif = true, webp = true, bmp = true, tiff = true }

local hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url)
end)

local next_icat_id = ya.sync(function(st)
	st.icat_seq = (st.icat_seq or 0) + 1
	return 10000000 + st.icat_seq
end)

local set_icat_id = ya.sync(function(st, id)
	local prev = st.icat_id
	st.icat_id = id
	return prev
end)

local function delete_image(id)
	local seq = string.format("\27_Gq=2,a=d,d=I,i=%d\27\\", id)
	Command("printf"):arg({ "%s", seq }):stdout(Command.INHERIT):status()
end

local function maximized()
	local r = rt.mgr.ratio
	return r[3] / (r[1] + r[2] + r[3]) > 0.9
end

local function icat(path, a, id)
	Command("kitten")
		:arg({
			"icat",
			"--stdin=no",
			"--transfer-mode=stream",
			"--scale-up",
			"--image-id",
			tostring(id),
			"--place",
			string.format("%dx%d@%dx%d", a.w, a.h, a.x, a.y),
			tostring(path),
		})
		:stdin(Command.NULL)
		:stdout(Command.INHERIT)
		:stderr(Command.NULL)
		:status()
end

function M:setup()
	ps.sub("hover", function()
		local id = self.icat_id
		if not id then
			return
		end

		local h = cx.active.current.hovered
		local mime = h and h:mime()
		local sub = mime and mime:match("^image/(.+)$")
		if maximized() and sub and ICAT_MIMES[sub] then
			return
		end

		self.icat_id = nil
		ya.emit("plugin", { "image-info", tostring(id) })
	end)
end

function M:entry(job)
	local id = tonumber(job.args[1])
	if id then
		delete_image(id)
	end
end

function M:peek(job)
	local start, url = os.clock(), ya.file_cache(job)
	if not url or not fs.cha(url) then
		url = Url(job.file.path)
	end

	local info = ya.image_info(Url(job.file.path))
	local img_area = info and job.area { h = math.max(0, job.area.h - 1) } or job.area

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

	if maximized() and info then
		local text = string.format("%dx%d", info.w, info.h)
		ya.preview_widget(job, ui.Text(text):area(job.area { y = img_area.y + img_area.h, h = 1 }))

		local me, id = tostring(job.file.url), next_icat_id()
		if hovered() ~= me then
			return
		end
		icat(job.file.path, img_area, id)
		if hovered() ~= me then
			return delete_image(id)
		end

		local prev = set_icat_id(id)
		if prev then
			delete_image(prev)
		end
		return
	end

	local rect, err = ya.image_show(url, img_area)
	local prev = set_icat_id(nil)
	if prev then
		delete_image(prev)
	end
	if err or not info then
		return ya.preview_widget(job, err)
	end

	local y = rect and rect.y + rect.h or img_area.y + img_area.h
	local text = string.format("%dx%d", info.w, info.h)
	ya.preview_widget(job, ui.Text(text):area(job.area { y = y, h = 1 }))
end

function M:seek() end

return M
