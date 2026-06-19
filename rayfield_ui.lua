-- [[ 🛑 Rayfieldライブラリの安全ロード（最大5回リトライ） ]]
local RayfieldLibrary = nil
for i = 1, 5 do
    local success, res = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    if success and res then
        RayfieldLibrary = res
        break
    end
    task.wait(0.5)
end

-- 万が一5回失敗した場合は警告を出して処理を止める
if not RayfieldLibrary then
    error("KTM HUB: Rayfield UI Libraryのダウンロードに失敗しました。時間をおいて再試行してください。")
    return
end

local player = game.Players.LocalPlayer

local Window = RayfieldLibrary:CreateWindow({
    Name = "KTM_HUB (FTAP)",
    LoadingTitle = "KTM_HUB Loading...",
    LoadingSubtitle = "by KTM",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KTM_Hub_Rayfield",
        FileName = "Config"
    }
})

local PlayerTab = Window:CreateTab("Player", 16630859927)

PlayerTab:CreateToggle({
    Name = "WalkspeedOverride",
    CurrentValue = false,
    Flag = "WalkspeedToggle",
    Callback = function(Value) _G.WalkspeedOverride = Value end
})

-- 🔒 修正: 余計な文字列（campaign）を完全に排除した綺麗なスライダー構造
PlayerTab:CreateSlider({
    Name = "Speed Multiplier",
    Info = "Walkspeed multiplier factor",
    Interact = "Drag",
    Pointer = "SpeedSlider",
    Suffix = "x",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value) _G.SpeedMultiplier = Value end
})

PlayerTab:CreateToggle({
    Name = "JumpPowerOverride",
    CurrentValue = false,
    Flag = "JumpToggle",
    Callback = function(Value) _G.JumpPowerOverride = Value end
})

PlayerTab:CreateSlider({
    Name = "Jump Multiplier",
    Info = "Jump power multiplier factor",
    Interact = "Drag",
    Pointer = "JumpSlider",
    Suffix = "x",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value) _G.JumpMultiplier = Value end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value) _G.InfiniteJump = Value end
})

PlayerTab:CreateSection("--- Camera Settings (TPS) ---")

PlayerTab:CreateToggle({
    Name = "Enable TPS (Max 500 Studs)", 
    CurrentValue = false, 
    Flag = "TPSToggleFlag",
    Callback = function(Value) 
        _G.TPSToggle = Value 
        if not Value and player then
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 12
            player.CameraMinZoomDistance = 0.5
        end
    end
})
