--[[
Open with encoding: UTF-8
StateHelper/core/utils.lua
]]

local utils = {}

function utils.sh_core_utils_compare_array(array1, array2)
    return compare_array(array1, array2)
end

function utils.sh_core_utils_compare_array_disable_order(array1, array2)
    return compare_array_disable_order(array1, array2)
end

function utils.sh_core_utils_round(num, decimals)
    return round(num, decimals)
end

return utils
