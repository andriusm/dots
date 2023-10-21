local M = {}

local function repo_name()
    local cmd = "git remote -v"
    local file = io.popen(cmd)
    local output = file:read("*l")  -- Read the first line
    file:close()

    if not output then
        return nil, "Failed to get git remote information"
    end

    local repo = output:match("github%.com[:/](.+)%.git")

    return repo
end

M.get_current_line_git_commit = function()
    local line_num = vim.fn.line('.')
    local file_path = vim.fn.expand('%:p')
    print(file_path)
    local cmd = string.format('git blame -L %d,%d -- %s | cut -f 1 -d " "', line_num, line_num, file_path)
    local commit_hash = vim.fn.system(cmd):gsub('\n', '')

    if #commit_hash == 0 then
        print("Error getting commit hash or not in a git repository.")
        return
    end

    cmd = string.format('git show -s --format="%%s" %s', commit_hash:gsub("^%^", ""))
    local commit_message = vim.fn.system(cmd)
    print(commit_message)

    local pr = commit_message:match("%(#(%d+)%)%s*$")
    cmd = string.format("open \"https://github.com/%s/pull/%s\"", repo_name(), pr)
    print(cmd)
    -- vim.fn.system(cmd)
end

return M

