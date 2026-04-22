--[[
Open with encoding: UTF-8
StateHelper/mechanics/common/members_board.lua
]]

local members_board = {}

function members_board.sh_mech_common_members_render()
    return render_members()
end

function members_board.sh_mech_common_members_update()
    return update_lists()
end

return members_board
