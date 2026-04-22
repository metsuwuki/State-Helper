--[[
Open with encoding: UTF-8
StateHelper/features/music/radio.lua
]]

local radio = {}

function radio.sh_feature_music_find_track(search_text, page)
    return find_track_link(search_text, page)
end

function radio.sh_feature_music_play(track_table, loop_track, index, song_tab)
    return play_song(track_table, loop_track, index, song_tab)
end

return radio
