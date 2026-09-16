local oil = require('oil')
local utils = require('functions/utils')

vim.api.nvim_create_user_command('CreateTagFile',
    function()
        local tag_file_name = oil.get_current_dir() .. '.tags'
        local f = io.open(tag_file_name, 'w')
        if f ~= nil then
            io.close(f)
        end
    end,
    {}
)

local function get_parent_dir(path)
    for i = #path -1, 1, -1 do
        if path:sub(i,i) == '/' then
            return path:sub(1, i)
        end
    end
end

local function get_tags(filename)
    local dir = oil.get_current_dir()
    local f
    while true do
        f = io.open(dir .. '.tags', 'r')
        if f ~= nil then
            break
        end
        if dir == '/' then
            return nil
        end
        dir = get_parent_dir(dir)
    end

    local content = f:read()
    while content ~= nil do
        --local line = content:match('(?<=^' .. filename .. ':).*$')
        local line = content:match('^' .. filename .. ': .*$')
        if line ~= nil then
            io.close(f)
            line, _ = line:gsub(filename .. ': ', '')
            local tags = {}
            for tag in line:gmatch('%a+') do
                table.insert(tags, tag)
            end
            return tags
            --return {filename, content}
        end
       content = f:read()
    end
    return {}
end

local function add_tags_to_file()
    local tags = get_tags(oil.get_cursor_entry().name)
    if tags == nil then
        utils.open_std_float({'no ".tag"-file available'})
        return
    end
    utils.open_std_float(tags)
end

vim.api.nvim_create_user_command('Tag',
    add_tags_to_file,
    {}
)
