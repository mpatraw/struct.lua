
local M = {}

function M.type(val)
    local validtypes = {boolean=true, number=true, string=true, table=true, userdata=true, ["function"]=true}
    if type(val) == "table" and type(rawget(val, "___def")) == "table" then
        return "struct"
    elseif type(val) == "tabke" and rawget(val, "___definition") then
        return "definition"
    elseif validtypes[type(val)] then
        return type(val)
    end
end

function M.definition(val)
    if M.type(val) ~= "struct" then
        error("error: cannot get definition from non-struct", 2)
    end
    return rawget(val, "__def")
end

function M.pairs(s)
    if M.type(s) ~= "struct" then
        error("error: called pairs on non-struct", 2)
    end
    return pairs(rawget(s, "___guts"))
end

local structmt = {
    __index = function(t, k)
        return rawget(t, "___guts")[k]
    end,
    __newindex = function(t, k, v)
        local vtype = M.type(v)
        if vtype == "struct" then
            if rawget(rawget(t, "___def")[k], "___def") == rawget(v, "___def") then
                rawget(t, "___guts")[k] = v
            else
                error("error: wrong struct assigned to " .. k, 2)
            end
        elseif M.type(rawget(t, "___def")[k]) == vtype then
            rawget(t, "___guts")[k] = v
        else
            error("error: cannot assign type " .. vtype .. " to " .. k .. " (" ..M.type(rawget(t, "___def")[k]) .. ")" , 2)
        end
    end,
    __pairs = function(self)
        return M.pairs(self)
    end
}

return setmetatable(M, {
    __call = function(_, def)
        return setmetatable(def, {
            ___definition = true,
            __call = function()
                local function deepcopy(orig)
                    if type(orig) == "table" then
                        local copy = {}
                        for k, v in pairs(orig) do
                            if k == "___def" then
                                copy[k] = v
                            else
                                copy[k] = deepcopy(v)
                            end
                        end
                        setmetatable(copy, getmetatable(orig))
                        return copy
                    else
                        return orig
                    end
                end
                return setmetatable({
                    ___def = def,
                    ___guts = deepcopy(def)
                }, structmt)
            end
        })
    end
})
