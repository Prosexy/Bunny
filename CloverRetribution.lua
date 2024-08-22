local Fluent = sexyfluent
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Demonic HUB | V2 | "..identifyexecutor(),
    SubTitle = "++ Clover Retribution",
    TabWidth = 117.5,
    Size = UDim2.fromOffset(545, 345),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Vampire",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    UpdateLog = Window:AddTab({ Title = "× Update-Log", Icon = "user-cog" }),
    Start = Window:AddTab({ Title = "× Information", Icon = "play" }),
    Main = Window:AddTab({ Title = "× Main Game", Icon = "home" }),
    Stat = Window:AddTab({ Title = "× Stats", Icon = "bar-chart" }),
    Quest = Window:AddTab({ Title = "× Quests", Icon = "newspaper" }),
    Item = Window:AddTab({ Title = "× Items", Icon = "box" }),
    Misc = Window:AddTab({ Title = "× Misc", Icon = "list" }),
    Player = Window:AddTab({ Title = "× Player", Icon = "user" }),
    Credits = Window:AddTab({Title = "× Credits",Icon = "hand" }),
    Settings = Window:AddTab({ Title = "× Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Plr = game.Players.LocalPlayer
local farmingmob
local ore
local mobs


local Mobs = {}
pcall(function()
for i,v in ipairs(workspace.Entities.Enemies:GetChildren()) do
if not table.find(Mobs,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
table.insert(Mobs,v.Name)
end
end
end)

local Quests = {}
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Quests:GetChildren()) do
if v:FindFirstChild("HumanoidRootPart") then
table.insert(Quests,v.Name)
end
end
end)

local SKills = {}
pcall(function()
for i,v in ipairs(Plr.Backpack:GetChildren()) do
if v:IsA("Tool") then
table.insert(SKills,v.Name)
end
end
end)

local rf = Tabs.Main:AddParagraph({
Title = "Current Farming Mob:",
Content = farmingmob
})

spawn(function()
while task.wait() do
rf:SetDesc(farmingmob)
end
end)

local updateParagraph = Tabs.UpdateLog:AddParagraph({
    Title = "Update Log:",
    Content = "V1.0:\nReleased!\nV1.25:\nOre Pick Aura, Farm Multiple Specific Ores, Auto Tundra Flowers, Auto GrassLand Flowers, Auto Grass, Added Sections, Improved Farm!\nV1.275:\nAuto Equip Weapon And Incresed The Max Distance Of Distance Slider Of AutoFarm.\nV1.3:\nInsta Kill\nV1.4:\nU Can Now Select Multiple And Farm Multiples Mobs-Bosses In Auto Farm Dropdown, Auto Skills With Auto Refresh Skills Dropdown, Auto Collect Dragonballs!",
    Section = true
})

Tabs.UpdateLog:AddParagraph({
Title = "Upcoming UPD:",
Content = "Custom AutoFarm!",
Section = true
})

Tabs.Start:AddParagraph({
Title = "Current Developers :",
Content = "alan11ago#8475, cheapsk9#0001"
})

Tabs.Start:AddParagraph({
Title = "Current Script Status :",
Content = "Working 🟢"
})

Tabs.Start:AddParagraph({
Title = "Supported Executors :",
Content = "Codex, Arceus X, Wave, Roexc-Krampus, Hydrogen, VegaX, Trigon"
})

Tabs.Start:AddParagraph({
Title = "Not Supported :",
Content = "Delta, Alyse, Valyse, Evon, Solara, Incognito"
})

local reset = Tabs.Main:AddDropdown("", {
Title = "Select Mob",
Description = "U Can Select Multiple Mobs!",
Values = Mobs,
Multi = true,
Default = {"¡Select Your Mobs!"}
})

reset:OnChanged(function(Value)
mobs = Value
end)

Tabs.Main:AddButton({
Title = "Refresh Options",
Description = "",
Callback = function()
pcall(function()
table.clear(Mobs)
task.wait(0.001)
for i,v in ipairs(workspace.Entities.Enemies:GetChildren()) do
if not table.find(Mobs,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
task.wait(0.05)
table.insert(Mobs,v.Name)
reset:SetValues(Mobs)
end
end
end)
end
})

Tabs.Main:AddDropdown("", {
Title = "Farm Method",
Description = "Above/Below (TP)",
Values = {"Above","Below","Front","Back","Spin Around"},
Multi = false,
Default = "",
Callback = function(t)
getgenv().Method = t
end
})


Tabs.Main:AddToggle("", {
Title = "Auto Farm Selected Mobs", 
Description = "Basically It Can Farm All The Selected Mobs From Mobs Multidropdown!",
Default = false,
Callback = function(t)
getgenv().AutoMob = t
while getgenv().AutoMob do
task.wait()
pcall(function()
for i,v in ipairs(workspace.Entities.Enemies:GetChildren()) do
if mobs[v.Name] == true and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health ~= 0 then

local Methods = {
     ["Above"] = v.HumanoidRootPart.CFrame * CFrame.new(0,getgenv().Dist,0) * CFrame.Angles(math.rad(180),0,0),
     ["Below"] = v.HumanoidRootPart.CFrame * CFrame.new(0,-getgenv().Dist,0) * CFrame.Angles(math.rad(180),0,0),
     ["Front"] = v.HumanoidRootPart.CFrame * CFrame.new(0,0,tonumber(getgenv().Dist)),
     ["Back"] = v.HumanoidRootPart.CFrame * CFrame.new(0,0,-tonumber(getgenv().Dist)),
     ["Spin Around"] = v.HumanoidRootPart.CFrame * CFrame.new(0,tonumber(getgenv().Dist),5)
}

Plr.Character.HumanoidRootPart.CFrame = Methods[getgenv().Method]

farmingmob = v.Name

local args = {
    [1] = "M1"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
break;
end
end
end)
end
end
})


Tabs.Main:AddToggle("", {
Title = "Auto Farm Random Mobs", 
Description = "",
Default = false,
Callback = function(t)
getgenv().AutoMobs = t
while getgenv().AutoMobs do
task.wait()
pcall(function()
for i,v in pairs(workspace.Entities.Enemies:GetChildren()) do
if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health ~= 0 then

local Methodss = {
     ["Above"] = v.HumanoidRootPart.CFrame * CFrame.new(0,getgenv().Dist,0) * CFrame.Angles(math.rad(180),0,0),
     ["Below"] = v.HumanoidRootPart.CFrame * CFrame.new(0,-getgenv().Dist,0) * CFrame.Angles(math.rad(180),0,0),
     ["Front"] = v.HumanoidRootPart.CFrame * CFrame.new(0,0,tonumber(getgenv().Dist)),
     ["Back"] = v.HumanoidRootPart.CFrame * CFrame.new(0,0,-tonumber(getgenv().Dist)),
     ["Spin Around"] = v.HumanoidRootPart.CFrame * CFrame.new(0,tonumber(getgenv().Dist),5)
}

Plr.Character.HumanoidRootPart.CFrame = Methodss[getgenv().Method]

farmingmob = v.Name

local args = {
    [1] = "M1"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
break;
end
end
end)
end
end
})

Tabs.Main:AddToggle("", {
Title = "Insta Kill", 
Description = "Only Works If The Health Is 20% Or Less!",
Default = false,
Callback = function(t)
getgenv().Insta = t
while getgenv().Insta do
task.wait()
pcall(function()
for i,v in ipairs(workspace.Entities.Enemies:GetChildren()) do
if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health ~= 0 and (v.HumanoidRootPart.Position - Plr.Character.HumanoidRootPart.Position).Magnitude < 200 and (v.Humanoid.Health <= v.Humanoid.MaxHealth / 5) then
v.Humanoid.Health = 0
end
end
end)
end
end
})

Tabs.Main:AddSection("Auto-Farm Settings")


Tabs.Main:AddSlider("Slider", {
Title = "Farm Distance",
Description = "",
Default = 2.5,
Min = 1.5,
Max = 25,
Rounding = 1,
Callback = function(t)
getgenv().Dist = t
end
})


Tabs.Main:AddToggle("", {
Title = "Auto M1", 
Description = "",
Default = false,
Callback = function(t)
getgenv().AutoMone = t
while getgenv().AutoMone do
task.wait()
local args = {
    [1] = "M1"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
})

Tabs.Main:AddSection("Skills")

local Skills = Tabs.Main:AddDropdown("", {
Title = "Select Skills",
Description = "Skills U Want To Auto Use, U Can Select Multiple!",
Values = SKills,
Multi = true,
Default = {"Select Your Skills!"},
})

Tabs.Main:AddToggle("", {
Title = "Auto Refresh Skills Dropdown", 
Description = "",
Default = false,
Callback = function(t)
getgenv().AutoRf = t
while getgenv().AutoRf do
task.wait(10)
pcall(function()
table.clear(SKills)
task.wait(0.01)
for i,v in ipairs(Plr.Backpack:GetChildren()) do
if v:IsA("Tool") then
task.wait(0.05)
table.insert(SKills,v.Name)
Skills:SetValues(SKills)
end
end
end)
end
end
})

Skills:OnChanged(function(Value)
skills = Value
end)

Tabs.Main:AddToggle("", {
Title = "Auto Use Skills", 
Description = "It Will Auto Use The Selected Skills From The Skills Multidropdown!",
Default = false,
Callback = function(t)
getgenv().AutoSkills = t
while getgenv().AutoSkills do
task.wait(3.75)
pcall(function()
for i,v in ipairs(Plr.Backpack:GetChildren()) do
if skills[v.Name] == true and v:IsA("Tool") then
local args = {
    [1] = "Toolbar",
    [2] = {
        ["mousetype"] = "M1",
        ["Tool"] = Plr.Backpack[v.Name]
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
end)
end
end
})

Tabs.Quest:AddDropdown("", {
Title = "Select Quest Marker",
Description = "",
Values = Quests,
Multi = false,
Default = "",
Callback = function(t)
getgenv().Quest = t
end
})

Tabs.Quest:AddButton({
Title = "Teleport + Interact",
Description = "",
Callback = function()
pcall(function()
Plr.Character:PivotTo(workspace.Entities.Interactions.Quests[getgenv().Quest]:GetPivot())
task.wait(0.2)
fireproximityprompt(v.HumanoidRootPart.Interaction)
end)
end
})

Tabs.Stat:AddToggle("", {
Title = "Auto Dexterity", 
Description = "",
Default = false,
Callback = function(t)
getgenv().one = t
while getgenv().one do
task.wait(3.5)
local args = {
    [1] = "StatDump",
    [2] = {
        ["Stat"] = "DEX",
        ["Dump"] = 1
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
})

Tabs.Stat:AddToggle("", {
Title = "Auto Strength", 
Description = "",
Default = false,
Callback = function(t)
getgenv().two = t
while getgenv().two do
task.wait(3.5)
local args = {
    [1] = "StatDump",
    [2] = {
        ["Stat"] = "STR",
        ["Dump"] = 1
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
})

Tabs.Stat:AddToggle("", {
Title = "Auto Intelligence", 
Description = "",
Default = false,
Callback = function(t)
getgenv().three = t
while getgenv().three do
task.wait(3.5)
local args = {
    [1] = "StatDump",
    [2] = {
        ["Stat"] = "INT",
        ["Dump"] = 1
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
})

Tabs.Stat:AddToggle("", {
Title = "Auto Constitution", 
Description = "",
Default = false,
Callback = function(t)
getgenv().four = t
while getgenv().four do
task.wait(3.5)
local args = {
    [1] = "StatDump",
    [2] = {
        ["Stat"] = "CON",
        ["Dump"] = 1
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end
})

Tabs.Item:AddSection("Ores")

local fm = Tabs.Item:AddParagraph({
Title = "Farming Ore:",
Content = ore
})

spawn(function()
while task.wait() do
fm:SetDesc(ore)
end
end)


Tabs.Item:AddToggle("", {
Title = "Auto Mine", 
Description = "It Will Mine All Ores Of Map!",
Default = false,
Callback = function(t)
getgenv().AutoMine = t
while getgenv().AutoMine do
task.wait()
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles:GetDescendants()) do
if v.Name == "OreSpawn" and v:FindFirstChild("ProximityPrompt") then
Plr.Character:PivotTo(v:GetPivot())
ore = v:GetAttribute("LinkedItem")
task.wait(0.2)
fireproximityprompt(v.ProximityPrompt)
Fluent:Notify({
Title = "Collected Ore:",
Content = v:GetAttribute("LinkedItem"),
SubContent = "",
Duration = 2.5
})
end
end
end)
end
end
})

Tabs.Item:AddToggle("", {
Title = "Ore Pick Up Aura", 
Description = "",
Default = false,
Callback = function(t)
getgenv().Aura = t
while getgenv().Aura do
task.wait(0.01)
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles:GetDescendants()) do
if v.Parent.Name == "OreSpawn" and v.Name == "ProximityPrompt" and (v.Parent:GetPivot().Position - Plr.Character.HumanoidRootPart.Position).Magnitude < 11 then
fireproximityprompt(v)
end
end
end)
end
end
})

Tabs.Item:AddSection("Custom Farm")

local ores
local cust = Tabs.Item:AddDropdown("", {
Title = "Target Ores",
Description = "U Can Select Multiple Ores!",
Values = {"Stone","Copper","Iron"},
Multi = true,
Default = {"Select Your Ores"}
})

cust:OnChanged(function(Value)
ores = Value
end)

Tabs.Item:AddToggle("", {
Title = "Auto Mine Target Ores", 
Description = "Basically It Checks If Theres Ores That Are Target On The MultiDropdown, If Theres And Its Target Then It Will Auto Mine!",
Default = false,
Callback = function(t)
getgenv().AutoTarget = t
while getgenv().AutoTarget do
task.wait(0.02)
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles:GetDescendants()) do
if v.Name == "OreSpawn" and v:FindFirstChild("ProximityPrompt") and ores[v:GetAttribute("LinkedItem")] == true then
Plr.Character:PivotTo(v:GetPivot())
ore = v:GetAttribute("LinkedItem")
task.wait(0.21)
fireproximityprompt(v.ProximityPrompt)
Fluent:Notify({
Title = "Collected Successfully The Target!",
Content = "Ore:",
SubContent = v:GetAttribute("LinkedItem"),
Duration = 5
})
end
end
end)
end
end
})

Tabs.Item:AddSection("Flowers, Grass Etc...")

Tabs.Item:AddToggle("", {
Title = "Auto Collect Flowers (Tundra)", 
Description = "Tundra Flowers",
Default = false,
Callback = function(t)
getgenv().Flowe = t
while getgenv().Flowe do
task.wait(0.01)
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles.Flowers.TundraFlowers:GetDescendants()) do
if v.Name == "ProximityPrompt" and v.Parent.Name == "Flower" then
Plr.Character:PivotTo(v.Parent:GetPivot())
task.wait(0.1)
fireproximityprompt(v)
Fluent:Notify({
Title = "Collected Flower:",
Content = v.Parent:GetAttribute("LinkedItem"),
SubContent = "",
Duration = 5
})
end
end
end)
end
end
})

Tabs.Item:AddToggle("", {
Title = "Auto Collect Flowers (GrassLand)", 
Description = "GrassLand Flowers",
Default = false,
Callback = function(t)
getgenv().Flowe = t
while getgenv().Flowe do
task.wait(0.01)
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles.Flowers.GrasslandFlowers:GetDescendants()) do
if v.Name == "ProximityPrompt" and v.Parent.Name == "Flower" then
Plr.Character:PivotTo(v.Parent:GetPivot())
task.wait(0.1)
fireproximityprompt(v)
Fluent:Notify({
Title = "Collected Flower:",
Content = v.Parent:GetAttribute("LinkedItem"),
SubContent = "",
Duration = 5
})
end
end
end)
end
end
})

Tabs.Item:AddToggle("", {
Title = "Auto Collect Grass", 
Description = "",
Default = false,
Callback = function(t)
getgenv().Grass = t
while getgenv().Grass do
task.wait(0.01)
pcall(function()
for i,v in ipairs(workspace.Entities.Interactions.Collectibles.Grass:GetDescendants()) do
if v.Name == "ProximityPrompt" and v.Parent.Name == "Grass" then
Plr.Character:PivotTo(v.Parent:GetPivot())
task.wait(0.1)
fireproximityprompt(v)
Fluent:Notify({
Title = "Collected Grass:",
Content = v.Parent:GetAttribute("LinkedItem"),
SubContent = "",
Duration = 5
})
end
end
end)
end
end
})

Tabs.Item:AddSection("Dragonballs")

Tabs.Item:AddToggle("", {
Title = "Auto Collect DragonBalls", 
Description = "If Theres A Dragonball The Script Will Detect It And It Will Auto TP + Collect!",
Default = false,
Callback = function(t)
getgenv().AutoDb = t
while getgenv().AutoDb do
task.wait()
pcall(function()
for i,v in ipairs(workspace.Ignore:GetChildren()) do
if string.find(v.Name,"Dragon Ball") and v:FindFirstChild("BallInteraction") then
Plr.Character:PivotTo(v:GetPivot())
task.wait(0.2)
fireproximityprompt(v.BallInteraction)
Fluent:Notify({
Title = "Collect Successfully DB:",
Content = v.Name,
SubContent = "",
Duration = 7.5
})
end
end
end)
end
end
})

Tabs.Misc:AddToggle("", {
Title = "Auto Equip Grimoire", 
Description = "It Grimoire Is Unequipped It Will Auto Detect And It Will Equip.",
Default = false,
Callback = function(t)
getgenv().AutoGrimo = t
while getgenv().AutoGrimo do
task.wait()
pcall(function()
if not workspace.Entities[Plr.Name]:FindFirstChild("Grimoire") then
local args = {
    [1] = "Book"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end)
end
end
})

Tabs.Misc:AddToggle("", {
Title = "Auto Equip Weapon", 
Description = "It Will Auto Equip Weapon If Its Unequipped!",
Default = false,
Callback = function(t)
getgenv().AutoWe = t
while getgenv().AutoWe do
task.wait()
pcall(function()
if not workspace.Entities[Plr.Name]:FindFirstChild("Weapon") then
local args = {
    [1] = "EquipWeapon"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
end)
end
end
})

Tabs.Misc:AddToggle("", {
Title = "Auto Spin (Only Works In Main Menu)", 
Description = "",
Default = false,
Callback = function(t)
getgenv().MainM = t
while getgenv().MainM do
task.wait(1.52)
game:GetService("Players").LocalPlayer:WaitForChild("Connector"):FireServer()
end
end
})

Tabs.Misc:AddButton({
Title = "Equip Grimoire",
Description = "",
Callback = function()
local args = {
    [1] = "Book"
}

game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedPackage"):WaitForChild("Remotes"):WaitForChild("action"):FireServer(unpack(args))
end
})

Tabs.Player:AddSlider("Slidper", {
Title = "WalkSpeed",
Description = "",
Default = 20,
Min = 20,
Max = 5000,
Rounding = 1,
Callback = function(t)
getgenv().Num = t
end
})


Tabs.Player:AddToggle("", {
Title = "Set WalkSpeed", 
Description = "",
Default = false,
Callback = function(t)
getgenv().AutoSpeed = t
while getgenv().AutoSpeed do
task.wait(0.001)
pcall(function()
Plr.Character.Humanoid.WalkSpeed = tonumber(getgenv().Num)
end)
end
end
})

Tabs.Player:AddSlider("Slidper", {
Title = "JumpPower",
Description = "",
Default = 20,
Min = 20,
Max = 500,
Rounding = 1,
Callback = function(t)
getgenv().Numm = t
end
})


Tabs.Player:AddToggle("", {
Title = "Set JumpPower", 
Description = "",
Default = false,
Callback = function(t)
getgenv().AutoJump = t
while getgenv().AutoJump do
task.wait(0.001)
pcall(function()
Plr.Character.Humanoid.JumpPower = tonumber(getgenv().Numm)
end)
end
end
})

Tabs.Credits:AddParagraph({
Title = "Credits To :",
Content = "alan11ago#8475"
})

Tabs.Credits:AddButton({
Title = "Copy Discord Server Inv",
Description = "It Copys To Clipboard The Inv To Server",
Callback = function()
setclipboard("https://discord.gg/W2KPqjbJvb")
end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Demonichub")
SaveManager:SetFolder("Demonichub/Project Mugetsu")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()