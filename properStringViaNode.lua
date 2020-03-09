local m = {}

local nodeRelativePath = "modules\\properStringViaNode\\node-v12.16.1-win-x86\\node"
local nodeFlags = "--experimental-modules --no-warnings"

local function getNodeExecutionCommand(siderDir, mjsRelativePath)
    local cmd =
        "\"" ..
        siderDir ..
        nodeRelativePath ..
        "\" " ..
        nodeFlags ..
        " \"" ..
        siderDir ..
        mjsRelativePath ..
        "\""

    return cmd
end

-- Reference: https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
local function spawn(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

-- Reference: https://stackoverflow.com/questions/34618946/lua-base64-encode
local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function encodeBase64(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local function properStringViaNode(siderDir, str)
    -- Encoding arguments with base64 to avoid the issues, see:
    -- https://github.com/nodejs/node/issues/21854 and
    -- https://github.com/PowerShell/PowerShell/issues/1995
    local cmd = getNodeExecutionCommand(siderDir, "modules\\properStringViaNode\\mjs\\properString.mjs")
        .. " " .. encodeBase64(siderDir)
        .. " " .. encodeBase64(str)

    -- Quoting the command is necessary
    -- Reference: https://stackoverflow.com/questions/53452818/lua-io-popen-run-program-with-space-in-path
    log(cmd)
    return spawn("\"" .. cmd .. "\"")

end

function m.init(ctx)
    log(properStringViaNode(ctx.sider_dir, "MESUT ÖZIL"));
end

return m
