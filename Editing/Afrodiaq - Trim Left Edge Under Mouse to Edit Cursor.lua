
local item = reaper.BR_ItemAtMouseCursor()

if not item then return end

local oldStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

reaper.Undo_BeginBlock()

reaper.Main_OnCommand(41300, 0)

local newStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
local delta = newStart - oldStart

if math.abs(delta) > 0.0000001 then

    local retval, numMarkers, numRegions = reaper.CountProjectMarkers(0)

    for i = 0, numMarkers + numRegions - 1 do

        local _, isRegion, pos, rgnEnd, name, idx =
            reaper.EnumProjectMarkers(i)

        if isRegion then
            if oldStart >= pos and oldStart <= rgnEnd then
                reaper.SetProjectMarker(
                    idx,
                    true,
                    pos + delta,
                    rgnEnd,
                    name
                )
                break
            end
        end

    end
end

reaper.UpdateArrange()

reaper.Undo_EndBlock(
"Trim left edge + move region start",
-1)
