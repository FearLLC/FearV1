


--[[ Yes this is openSource :O

    And poorly coded :( , if you are able to teach me a lil but of advanced lua hit me up - SEASONAL#8280 -

    WE HIGHLY RECCOMEND USING THE MAIN LOADSTRING,
    AS IT WILL BE UPDATE WITH FIXES AND UPDATES :).

    Join discord for more opensource script - https://discord.gg/BWpBU6Cy4j

]]--



--------------

function randomString() -- This from infinity yield
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local randomName = tostring(randomString())
local lplr = game:GetService("Players").LocalPlayer
local plrs = game:GetService("Players")
local camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local char = lplr.Character
local TeleportService = game:GetService("TeleportService")
local GameList = loadstring(game:HttpGet("https://raw.githubusercontent.com/FearLLC/FearV1/main/GameList.lua",true))()

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local settings = {
    toggle = false,
    highlightVisuals = {
        DepthMode = "AlwaysOnTop", -- AlwaysOnTop, Occluded
        FillColor = Color3.new(0, 0, 0),
        FillTransparency = 0,
        OutlineColor = Color3.new(255, 255, 255),
        OutlineTransparency = 0,
    },
    textVisuals = {
        Size = UDim2.new(0, 200, 0, 250),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    },
}

local spectate = nil
local gotoPlayer = nil

-- << FUNCTIONS >> --

local function applyEsp(plr)
    if settings.toggle then
        repeat wait() until plr
        repeat wait() until plr.Humanoid

        local highlight = Instance.new("Highlight")
        highlight.Parent = plr
        highlight.Name = randomName
        highlight.DepthMode = settings.highlightVisuals.DepthMode
        highlight.FillColor = settings.highlightVisuals.FillColor 
        highlight.FillTransparency = settings.highlightVisuals.FillTransparency
        highlight.OutlineColor = settings.highlightVisuals.OutlineColor
        highlight.OutlineTransparency = settings.highlightVisuals.OutlineTransparency

        local billboardgui = Instance.new("BillboardGui")
        billboardgui.Parent = plr
	    billboardgui.AlwaysOnTop = true
	    billboardgui.MaxDistance = math.huge
        billboardgui.Adornee = plr
        billboardgui.Size = UDim2.new(0, 200, 0, 100)
        billboardgui.Active = true
        billboardgui.Enabled = true
        billboardgui.LightInfluence = 1
        billboardgui.AutoLocalize = true
        billboardgui.Name = randomName
        local textlabel = Instance.new("TextLabel")
	    textlabel.Parent = billboardgui
        textlabel.BackgroundTransparency = 1
        textlabel.Text = tostring(plr).."\n"..plr.Humanoid.Health
        plr.Humanoid.Changed:Connect(function(Prop)
            if Prop == "Health" then
                textlabel.Text = tostring(plr).."\n"..plr.Humanoid.Health
            end
        end)
	    textlabel.Size = settings.textVisuals.Size
        textlabel.BorderSizePixel = 0
        textlabel.TextColor3 = settings.textVisuals.TextColor3

    end
end

local function toggleStart()

    for _,v in pairs(plrs:GetPlayers()) do
        if v ~= lplr and v.Character:FindFirstChild("HumanoidRootPart") then
            applyEsp(v.Character)

            v.CharacterAdded:Connect(function(character)
                applyEsp(character)
            end)
        end
    end

    plrs.PlayerAdded:Connect(function(player)
        if player ~= lplr then
            repeat wait() until player.Character
            applyEsp(player.Character)

            player.CharacterAdded:Connect(function(character)
                applyEsp(character)
            end)
        end
    end)

end 

local function destroyEsp()
    for _,v in pairs(plrs:GetPlayers()) do
        for _,des in pairs(v.Character:GetDescendants()) do
            if des.Name == randomName then
                des:Destroy()
            end
        end
    end
end

local function changeFov(fov: number)
    camera.FieldOfView = fov
end

local function noclip(boolCheck: boolean, boolApply: boolean)
    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	    if v:IsA("BasePart") and v.CanCollide == boolCheck and v.Name ~= randomName then
		    v.CanCollide = boolApply
	    end
    end
end

-- << UI >> --

local Window = Library:CreateWindow({
    Title = 'Fear - V1',
    Center = true,
    AutoShow = false,
    TabPadding = 3
})

-- << TABS >> --

local Tabs = {
    lplr = Window:AddTab('Local Player'),
    ESP = Window:AddTab('ESP'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- << LOCAL PLAYER >> --

local LocalPlayerMiscSettings = Tabs.lplr:AddRightGroupbox('Misc')

LocalPlayerMiscSettings:AddButton({
    Text = 'Reset',
    Func = function()
        char.Head:Destroy()
    end,
    DoubleClick = false,
    Tooltip = 'Resets Character'
})

LocalPlayerMiscSettings:AddButton({
    Text = 'Rejoin',
    Func = function()
        lplr:Kick("\nRejoining...")
        task.wait()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lplr)
    end,
    DoubleClick = false,
    Tooltip = 'Rejoins Server'
})

LocalPlayerMiscSettings:AddToggle('Noclip', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'HIGHLY RECCOMENDED TURNING OFF ESP WHEN UNLOADING GUI',

    Callback = function(Value)
        if Value then
            noclip(true, false)
        else
            noclip(false, true)
        end
    end
})

local LocalPlayerSettings = Tabs.lplr:AddLeftGroupbox('Modifications')

LocalPlayerSettings:AddSlider('WalkSpeed', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        char.Humanoid.WalkSpeed = Value
    end
})

LocalPlayerSettings:AddSlider('JumpPower', {
    Text = 'JumpPower',
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        char.Humanoid.JumpPower = Value
    end
})

LocalPlayerSettings:AddSlider('Gravity', {
    Text = 'Gravity',
    Default = 200,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})

-- << MISC >> --

local MiscSettings = Tabs.Misc:AddLeftGroupbox('FOV')

MiscSettings:AddSlider('FOV', {
    Text = 'FOV',
    Default = 80,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        changeFov(Value)
    end
})

local SpectateSettings = Tabs.Misc:AddLeftGroupbox('Spectate')

SpectateSettings:AddInput('SpectateInput', {
    Default = 'Input Username...',
    Numeric = false,
    Finished = true,

    Text = 'Spectate',
    Tooltip = 'Player To Spectate',

    Placeholder = 'Name...',

    Callback = function(Value)
        spectate = Value
    end
})

SpectateSettings:AddToggle('Spectate', {
    Text = 'Spectate',
    Default = false,
    Tooltip = 'Spectate Player Thats Been Inputted',

    Callback = function(Value)
        if Value then
            for _,v in pairs(plrs:GetPlayers()) do
                if v.Name == spectate then
                    camera.CameraSubject = v.Character
                end
            end
        else
            camera.CameraSubject = lplr.Character
        end
    end
})

local GotoSettings = Tabs.Misc:AddRightGroupbox('Goto')

GotoSettings:AddInput('GotoInput', {
    Default = 'Input Username...',
    Numeric = false,
    Finished = true,

    Text = 'Goto',
    Tooltip = 'Player To Goto',

    Placeholder = 'Name...',

    Callback = function(Value)
        gotoPlayer = Value
    end
})

GotoSettings:AddButton({
    Text = 'Goto',
    Func = function()
        char.HumanoidRootPart.CFrame = plrs[gotoPlayer].Character.HumanoidRootPart.CFrame
    end,
    DoubleClick = false,
    Tooltip = 'Goes to inputted player'
})

local ScriptSettings = Tabs.Misc:AddRightGroupbox('Scripts')

ScriptSettings:AddInput('Link', {
    Default = 'Input Link...',
    Numeric = false,
    Finished = true,

    Text = 'Link',
    Tooltip = 'Link To Load',

    Placeholder = 'Name...',

    Callback = function(Value)
        loadstring(game:HttpGet(tostring(Value),true))()
    end
})

ScriptSettings:AddButton({
    Text = 'Infinity Yield',
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
    DoubleClick = false,
    Tooltip = 'Infinity Yield'
})

ScriptSettings:AddButton({
    Text = 'Http-Spy',
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fortnitemodder/Https-Spy/main/Enhanced"))()
    end,
    DoubleClick = false,
    Tooltip = 'Http-Spy'
})

-- << ESP >> --

local MainEsp = Tabs.ESP:AddLeftGroupbox('Main')

MainEsp:AddToggle('Toggle', {
    Text = 'Toggle',
    Default = false,
    Tooltip = 'HIGHLY RECCOMENDED TURNING OFF ESP WHEN UNLOADING GUI',

    Callback = function(Value)
        settings.toggle = Value
        if Value then
            toggleStart()
        else
            destroyEsp()
        end
    end
})

local HighlightSettings = Tabs.ESP:AddLeftGroupbox('Highlight') -- highlightVisuals

HighlightSettings:AddDropdown('DepthMode', {
    Values = {'AlwaysOnTop', 'Occluded'},
    Default = 1,
    Multi = false,

    Text = 'DepthMode',
    Tooltip = 'Highlight Viewing',

    Callback = function(Value)
        settings.highlightVisuals.DepthMode = Value
    end
})

HighlightSettings:AddLabel('FillColor'):AddColorPicker('FillColor', {
    Default = Color3.new(0, 0, 0),
    Title = 'FillColor', 
    Transparency = 0,

    Callback = function(Value)
        settings.highlightVisuals.FillColor = Value
    end
})

HighlightSettings:AddSlider('FillTransparency', {
    Text = 'FillTransparency',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        settings.highlightVisuals.FillTransparency = Value
    end
})

HighlightSettings:AddLabel('OutlineColor'):AddColorPicker('OutlineColor', {
    Default = Color3.new(0, 0, 0),
    Title = 'OutlineColor',
    Transparency = 0,

    Callback = function(Value)
        settings.highlightVisuals.OutlineColor = Value
    end
})

HighlightSettings:AddSlider('OutlineTransparency', {
    Text = 'OutlineTransparency',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        settings.highlightVisuals.OutlineTransparency = Value
    end
})

local TextSettings = Tabs.ESP:AddRightGroupbox('Text')

TextSettings:AddLabel('TextColor3'):AddColorPicker('TextColor3', {
    Default = Color3.new(1.0, 1.0, 1.0),
    Title = 'TextColor3',
    Transparency = 0,

    Callback = function(Value)
        settings.textVisuals.TextColor3 = Value
    end
})

TextSettings:AddSlider('PlaceMent', {
    Text = 'PlaceMent {up and down}',
    Default = 250,
    Min = 0,
    Max = 250,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        settings.textVisuals.Size = UDim2.new(0, 200, 0, Value)
    end
})


-- << UI Settings >> --

local Games = Tabs['UI Settings']:AddRightGroupbox('Games')

Games:AddLabel(GameList, true)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()
    Library:Unload()
    settings.toggle = false
    destroyEsp()
    camera.CameraSubject = lplr.Character
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('FearV1')
ThemeManager:ApplyToTab(Tabs['UI Settings'])

local function loggedIn()
    if lplr.Name == "SeasonalKirito" then
        return "Developer"
    else
        return "User"
    end
end

Library:SetWatermark(game.PlaceId..' | Fear - V1 | '..loggedIn())

Library:Notify(" - Loaded - ", 3)
Library:Notify(" - ESC - is default keybind.", 5)
Library:Notify("Thanks for using Fear - V1, User register as - "..loggedIn(), 5)
