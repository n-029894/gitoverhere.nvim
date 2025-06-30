local M = {}

function M.setup()
    -- Placeholder
end

local function repo_url()
    local url = vim.fn.systemlist("git remote -v  > /dev/null 2>&1 | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's/.git$//'")[1]

    if url ~= "" then
        return url
    else
        return ""
    end
end

local function branch(opts)
    b = vim.fn.systemlist("git remote show origin | awk '/HEAD branch/{print $3}'")[1]
    if opts.target ~= "default" then
	    b = vim.fn.systemlist("git branch --show-current 2> /dev/null")[1]
    end
    return b
end

local function directory_path()
    local current_git_path = vim.fn.systemlist("git rev-parse --show-prefix")[1]
    if current_git_path == nil then
        current_git_path = "/"
    end

    local full_file_path = vim.fn.expand('%:p')
    local cwd = string.gsub(vim.fn.getcwd(), '%-', '%%-')
    local relative_file_path = string.gsub(full_file_path, cwd .. "/", "")

    local path = {
        current_git_path,
        relative_file_path
    }
    return table.concat(path, "")
end

local function git_file_location(opts)
    local b = branch({target=opts.targetBranch})

    local location = {repo_url(), "/blob/", b, "/", directory_path()}

    return table.concat(location, "")
end

vim.api.nvim_create_user_command("GitOverHere", function(opts)
        copyAction = false
        branchTarget = false

        for _, arg in ipairs(vim.split(opts.args, " ")) do
            if arg == "copy" then
                copyAction = true
            elseif arg == "branch" then
                branchTarget = true
            end
        end

        -- if opts.args and opts.args:match("branch") then
        if branchTarget then
            url = git_file_location({targetBranch="current"})
        else
            url = git_file_location({targetBranch="default"})
        end

        -- Don't return formatted markdown links
        if string.find(url, ".md$") then
            url = url .. "?plain=1"
        end

        -- Account for range selections
        -- Get the start and end positions of the visual selection
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")

        -- Extract line numbers (second element of the position array)
        local start_line = start_pos[2]
        local end_line = end_pos[2]

        if start_line ~= end_line then
            url = url .. "#L" .. start_line .. "-L" .. end_line
        elseif start_line == end_line and start_line ~= 0 then
            url = url .. "#L" .. start_line
        end

        -- Check if 'copy' argument was passed
        if copyAction then
            vim.fn.system("echo '" .. url .. "' | pbcopy")
            vim.print("Copied to clipboard: " .. url)
        else
            vim.fn.system("open '" .. url .. "'")
        end
    end,
    {
        desc = "Open the current file in the browser, or copy URL with 'copy' argument",
        nargs = "*",
        range = true,
    }
)
