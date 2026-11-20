local M = {}

function M:peek(job)
	local start, url = os.clock(), ya.file_cache(job)
	if not url or not fs.cha(url) then
		url = Url(job.file.path)
	end

	local info = ya.image_info(Url(job.file.path))
	local img_area = info and job.area { h = math.max(0, job.area.h - 1) } or job.area

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	local rect, err = ya.image_show(url, img_area)
	if err or not info then
		return ya.preview_widget(job, err)
	end

	local y = rect and rect.y + rect.h or img_area.y + img_area.h
	local text = string.format("%dx%d", info.w, info.h)
	ya.preview_widget(job, ui.Text(text):area(job.area { y = y, h = 1 }))
end

function M:seek() end

return M
