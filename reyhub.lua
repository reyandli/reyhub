--[[
    ===================================================================
    PROJECT: REY HUB | BETA (STEAL AN EGG - COMBO ANTI-KICK EDITION)
    GAME: Steal An Egg (Roblox)
    FIXED VERSION - No Crash / Stable Execute
    ===================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- ==========================================
-- SERVICES & LOCALPLAYER (GLOBAL SCOPE)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

-- ==========================================
-- 🛡️ EXUNYS ANTI-KICK MODULE (FIXED)
-- ==========================================
local getgenv = getgenv or function() return _G end
local getnamecallmethod = getnamecallmethod
local hookmetamethod = hookmetamethod
local hookfunction = hookfunction
local newcclosure = newcclosure
local checkcaller = checkcaller
local lower = string.lower
local gsub = string.gsub
local match = string.match

if not getgenv().ED_AntiKick then
    local cloneref = cloneref or function(...) return ... end
    local clonefunction = clonefunction or function(...) return ... end

    local SetCore = clonefunction(StarterGui.SetCore)
    local FindFirstChild = clonefunction(game.FindFirstChild)

    local function CompareInstances(Instance1, Instance2)
        return typeof(Instance1) == "Instance" and typeof(Instance2) == "Instance" and Instance1 == Instance2
    end

    local function CanCastToSTDString(...)
        return pcall(FindFirstChild, game, ...)
    end

    getgenv().ED_AntiKick = {
        Enabled = true,
        SendNotifications = true,
        CheckCaller = true
    }

    -- Namecall Hook
    if hookmetamethod and newcclosure and getnamecallmethod then
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local self = ...
            local method = getnamecallmethod()

            local shouldBlock = getgenv().ED_AntiKick.Enabled
                and CompareInstances(self, LocalPlayer)
                and gsub(method, "^%l", string.upper) == "Kick"

            if shouldBlock then
                if getgenv().ED_AntiKick.CheckCaller then
                    if checkcaller and checkcaller() then
                        return OldNamecall(...)
                    end
                end

                local message = select(2, ...)
                if CanCastToSTDString(message) then
                    if getgenv().ED_AntiKick.SendNotifications then
                        pcall(function()
                            SetCore(StarterGui, "SendNotification", {
                                Title = "ReyHub - Anti-Kick",
                                Text = "Successfully intercepted an attempted kick.",
                                Icon = "rbxassetid://6238540373",
                                Duration = 2
                            })
                        end)
                    end
                    return nil
                end
            end

            return OldNamecall(...)
        end))
    end

    -- Function Hook (FIXED: selalu panggil original)
    if hookfunction then
        local OldKick
        OldKick = hookfunction(LocalPlayer.Kick, function(self, Message)
            local shouldBlock = getgenv().ED_AntiKick.Enabled and CompareInstances(self, LocalPlayer)

            if shouldBlock then
                if getgenv().ED_AntiKick.CheckCaller then
                    if checkcaller and checkcaller() then
                        return OldKick(self, Message)
                    end
                end

                if CanCastToSTDString(Message) then
                    if getgenv().ED_AntiKick.SendNotifications then
                        pcall(function()
                            SetCore(StarterGui, "SendNotification", {
                                Title = "ReyHub - Anti-Kick",
                                Text = "Successfully intercepted an attempted kick.",
                                Icon = "rbxassetid://6238540373",
                                Duration = 2
                            })
                        end)
                    end
                    return
                end
            end

            return OldKick(self, Message)
        end)
    end

    if getgenv().ED_AntiKick.SendNotifications then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "ReyHub - Anti-Kick",
                Text = "Anti-Kick script loaded!",
                Icon = "rbxassetid://6238537240",
                Duration = 3
            })
        end)
    end
end

-- ==========================================
-- ⚡ REY HUB MAIN ENGINE & UI
-- ==========================================
local currentFPS = 60
local frameTimes = {}

RunService.RenderStepped:Connect(function(dt)
    table.insert(frameTimes, dt)
    if #frameTimes > 30 then
        table.remove(frameTimes, 1)
    end
    local total = 0
    for _, t in ipairs(frameTimes) do
        total = total + t
    end
    if total > 0 then
        currentFPS = math.floor(30 / total)
    end
end)

getgenv().ReyHubConfig = {
    AutoLabAFK = false,
    TargetExperimental = true,
    TargetBiohazard = true,
    TargetUnstableDNA = true,
    SmartReroll = true,
    AutoDepositRawEgg = true,

    AutoStealMap = false,
    SelectedBiome = "Forest",
    TargetRarity = "Divine",
    AutoReturnBase = true,

    AutoChasePlayer = false,
    TargetPlayerName = "None",
    ChaseActive = false,

    AutoHatch = false,
    AutoEquipBest = true,
    AutoSellEgg = false,
    SellEggCategory = "Common",

    AutoTreadmill = false,
    WalkSpeed = 40,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,

    AutoServerHop = false,
    MaxServerPlayers = 3,

    EspEggs = true,
    CustomFPSTarget = 60,
    PotatoGraphics = false,
    DisableShadows = true,
    FullBright = true
}

local LabState = {
    NeededEggs = {},
    CurrentRerolls = 0,
    CurrentTask = "Idle"
}

-- Hapus UI lama jika ada
pcall(function()
    if CoreGui:FindFirstChild("ReyHubBeta") then
        CoreGui.ReyHubBeta:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHubBeta"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ REY HUB | BETA [COMBO ANTI-KICK]"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -11)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14

local MinimizeC = Instance.new("UICorner")
MinimizeC.CornerRadius = UDim.new(0, 4)
MinimizeC.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -11)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11

local CloseC = Instance.new("UICorner")
CloseC.CornerRadius = UDim.new(0, 4)
CloseC.Parent = CloseBtn

-- Logo Button (muncul saat UI di-minimize/close)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "ReyHubLogo"
LogoBtn.Parent = ScreenGui
LogoBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
LogoBtn.Position = UDim2.new(0, 20, 0.5, -25)
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Font = Enum.Font.GothamBold
LogoBtn.Text = "⚡"
LogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoBtn.TextSize = 24
LogoBtn.Visible = false
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.ZIndex = 10

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(255, 255, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = LogoBtn

-- Fungsi hide/show UI
local function hideUI()
    MainFrame.Visible = false
    LogoBtn.Visible = true
end

local function showUI()
    MainFrame.Visible = true
    LogoBtn.Visible = false
end

MinimizeBtn.MouseButton1Click:Connect(hideUI)
CloseBtn.MouseButton1Click:Connect(hideUI)
LogoBtn.MouseButton1Click:Connect(showUI)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(0, 130, 1, -40)
TabBar.CanvasSize = UDim2.new(0, 0, 2.5, 0)
TabBar.ScrollBarThickness = 2

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.Padding = UDim.new(0, 4)

local pages = {}

local function createPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name .. "Page"
    sf.Parent = MainFrame
    sf.Active = true
    sf.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    sf.BorderSizePixel = 0
    sf.Position = UDim2.new(0, 138, 0, 48)
    sf.Size = UDim2.new(1, -148, 1, -55)
    sf.CanvasSize = UDim2.new(0, 0, 3.8, 0)
    sf.ScrollBarThickness = 3
    sf.Visible = false

    local list = Instance.new("UIListLayout")
    list.Parent = sf
    list.Padding = UDim.new(0, 6)

    pages[name] = sf
    return sf
end

local pLab = createPage("Dr. Scramble")
local pSteal = createPage("Steal Map")
local pSniper = createPage("PVP Chase")
local pHatch = createPage("Pets & Sell")
local pMove = createPage("Movement")
local pHop = createPage("Server Hop")
local pSettings = createPage("Settings")

local function addTabBtn(name, target)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = " " .. name
    btn.TextColor3 = Color3.fromRGB(190, 190, 190)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do
            p.Visible = false
        end
        target.Visible = true
    end)
end

addTabBtn("🧬 Dr. Scramble", pLab)
addTabBtn("🥚 Steal Map", pSteal)
addTabBtn("🎯 PVP Chase", pSniper)
addTabBtn("🐾 Pets & Sell", pHatch)
addTabBtn("⚡ Movement", pMove)
addTabBtn("🌐 Server Hop", pHop)
addTabBtn("⚙️ Settings", pSettings)

pLab.Visible = true

local function addToggle(parent, name, key)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. name .. ": " .. (getgenv().ReyHubConfig[key] and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(210, 210, 210)
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ReyHubConfig[key] = not getgenv().ReyHubConfig[key]
            local state = getgenv().ReyHubConfig[key]
            btn.Text = "  " .. name .. ": " .. (state and "ON" or "OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(100, 200, 50) or Color3.fromRGB(30, 30, 40)
        end)
    end)
end

local function addSelector(parent, name, options, key)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. name .. " [" .. tostring(getgenv().ReyHubConfig[key]) .. "]"
    btn.TextColor3 = Color3.fromRGB(190, 190, 190)
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    local idx = 1
    for i, v in ipairs(options) do
        if v == getgenv().ReyHubConfig[key] then
            idx = i
            break
        end
    end

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            idx = idx + 1
            if idx > #options then idx = 1 end
            local chosen = options[idx]
            getgenv().ReyHubConfig[key] = chosen
            btn.Text = "  " .. name .. " [" .. tostring(chosen) .. "]"
        end)
    end)
end

-- Lab Info Label
local labInfo = Instance.new("TextLabel")
labInfo.Parent = pLab
labInfo.BackgroundTransparency = 1
labInfo.Size = UDim2.new(1, 0, 0, 55)
labInfo.Font = Enum.Font.Gotham
labInfo.Text = "Task: Idle\nTarget Telur: Memindai...\nGulung Ulang: 0/3"
labInfo.TextColor3 = Color3.fromRGB(150, 255, 50)
labInfo.TextSize = 11
labInfo.TextXAlignment = Enum.TextXAlignment.Left

addToggle(pLab, "▶️ AKTIFKAN FULL AFK LAB (MENTAHAN)", "AutoLabAFK")
addToggle(pLab, "Incar Mutasi: Experimental Pets", "TargetExperimental")
addToggle(pLab, "Incar Mutasi: Biohazard Pets", "TargetBiohazard")
addToggle(pLab, "Incar Mutasi: Unstable DNA", "TargetUnstableDNA")
addToggle(pLab, "Smart Reroll (Max 3x Gratis)", "SmartReroll")
addToggle(pLab, "Auto Curi -> Langsung Setor ke Lab", "AutoDepositRawEgg")

addToggle(pSteal, "Jalan Otomatis Curi Telur", "AutoStealMap")
addSelector(pSteal, "Pilih Biome Map", {"Forest", "Lake", "Desert", "Jungle", "Cherry Blossom", "Snow", "Volcano", "Abyss", "Angels & Demons"}, "SelectedBiome")
addSelector(pSteal, "Target Rarity Telur", {"Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Eternal", "Kosmik", "Secret"}, "TargetRarity")
addToggle(pSteal, "Lari Balik Ke Base Jika Dapat", "AutoReturnBase")
addToggle(pSteal, "ESP Radar Telur di Map", "EspEggs")

addToggle(pSniper, "Auto Kejar Semua Target Bawa Telur", "AutoChasePlayer")

addToggle(pHatch, "Auto Hatch Eggs (Manual Hatch)", "AutoHatch")
addToggle(pHatch, "Auto Equip Best Pets", "AutoEquipBest")
addToggle(pHatch, "Auto Sell Egg (Jual Telur)", "AutoSellEgg")
addSelector(pHatch, "Kategori Jual Rarity", {"Common", "Rare", "Epic", "Legendary", "Mythic"}, "SellEggCategory")

addToggle(pMove, "Lari Otomatis di Treadmill", "AutoTreadmill")
addSelector(pMove, "WalkSpeed Lari", {16, 30, 40, 50, 60}, "WalkSpeed")
addToggle(pMove, "Infinite Jump (Terbang)", "InfiniteJump")
addToggle(pMove, "Noclip (Tembus Tembok)", "Noclip")

addToggle(pHop, "Aktifkan Auto Server Hop", "AutoServerHop")
addSelector(pHop, "Max Player per Server", {1, 2, 3, 4, 5, 6, 7}, "MaxServerPlayers")

addSelector(pSettings, "Target Batas FPS", {30, 60, 120}, "CustomFPSTarget")
addToggle(pSettings, "Potato Graphics", "PotatoGraphics")
addToggle(pSettings, "FullBright", "FullBright")

-- ==========================================
-- HELPER FUNCTIONS (SAFE)
-- ==========================================
local function getPlayerBasePosition()
    local pos = Vector3.new(0, 10, 0)
    pcall(function()
        local bases = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Tycoons")
        if bases then
            for _, b in pairs(bases:GetChildren()) do
                local ownerValue = b:FindFirstChild("Owner")
                if (ownerValue and tostring(ownerValue.Value) == LocalPlayer.Name) or b.Name == LocalPlayer.Name then
                    local dropoff = b:FindFirstChild("Dropoff") or b:FindFirstChild("SpawnLocation")
                    if dropoff and dropoff:IsA("BasePart") then
                        pos = dropoff.Position
                        break
                    end
                end
            end
        end
    end)
    return pos
end

local function scanDrScrambleUI()
    local needed = {}
    pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("DrScrambleUI") or LocalPlayer.PlayerGui:FindFirstChild("LabUI")
        if gui then
            for _, v in pairs(gui:GetDescendants()) do
                if v:IsA("TextLabel") then
                    local text = v.Text:lower()
                    if text:match("telur") and not text:match("/") then
                        table.insert(needed, v.Text)
                    end
                end
            end
        end
    end)
    return needed
end

local function triggerReroll()
    pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("DrScrambleUI") or LocalPlayer.PlayerGui:FindFirstChild("LabUI")
        if gui then
            for _, v in pairs(gui:GetDescendants()) do
                if v:IsA("TextButton") and v.Text:lower():match("gulung ulang") then
                    if firesignal then
                        firesignal(v.MouseButton1Click)
                    end
                    task.wait(1.5)
                    break
                end
            end
        end
    end)
end

local function findEggInMap(specificName)
    local targetEgg = nil
    pcall(function()
        local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("MapEggs") or Workspace
        if eggsFolder then
            for _, egg in pairs(eggsFolder:GetDescendants()) do
                if egg:IsA("BasePart") and egg.Name:lower():match("egg") then
                    if specificName then
                        if egg.Name:lower():match(specificName:lower()) then
                            targetEgg = egg
                            break
                        end
                    else
                        targetEgg = egg
                        break
                    end
                end
            end
        end
    end)
    return targetEgg
end

local function safeFireTouch(hrp, part)
    if not hrp or not part then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(hrp, part, 0)
            task.wait(0.15)
            firetouchinterest(hrp, part, 1)
        end
    end)
end

-- ==========================================
-- MAIN LOOP (STABLE)
-- ==========================================
task.spawn(function()
    while true do
        local adaptiveDelay = (currentFPS < 22) and 0.5 or 0.25
        task.wait(adaptiveDelay)

        pcall(function()
            local cfg = getgenv().ReyHubConfig
            if not cfg then return end

            local char = LocalPlayer.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid or humanoid.Health <= 0 then return end

            -- FPS Cap
            if setfpscap then
                pcall(setfpscap, cfg.CustomFPSTarget or 60)
            end

            local hasEgg = char:FindFirstChild("Egg")
                or char:FindFirstChild("CarriedEgg")
                or char:FindFirstChildOfClass("Tool")

            -- ========== LAB AFK ==========
            if cfg.AutoLabAFK then
                local labMachine = Workspace:FindFirstChild("DrScrambleLab") or Workspace:FindFirstChild("Laboratory")

                if labMachine then
                    local mainPart = labMachine:FindFirstChild("MainPart") or labMachine:FindFirstChildWhichIsA("BasePart")

                    if mainPart then
                        if #LabState.NeededEggs == 0 then
                            LabState.CurrentTask = "Scanning UI..."
                            humanoid:MoveTo(mainPart.Position)

                            if (hrp.Position - mainPart.Position).Magnitude <= 12 then
                                local scanned = scanDrScrambleUI()
                                if #scanned > 0 then
                                    if cfg.SmartReroll and LabState.CurrentRerolls < 3 then
                                        local isEggExist = findEggInMap(scanned[1])
                                        if not isEggExist then
                                            triggerReroll()
                                            LabState.CurrentRerolls = LabState.CurrentRerolls + 1
                                            task.wait(2)
                                            LabState.NeededEggs = scanDrScrambleUI()
                                        else
                                            LabState.NeededEggs = scanned
                                        end
                                    else
                                        LabState.NeededEggs = scanned
                                    end
                                end
                            end

                        elseif #LabState.NeededEggs > 0 and not hasEgg then
                            LabState.CurrentTask = "Mencari telur: " .. tostring(LabState.NeededEggs[1])
                            local targetBahan = findEggInMap(LabState.NeededEggs[1])

                            if targetBahan then
                                humanoid:MoveTo(targetBahan.Position)
                                if (hrp.Position - targetBahan.Position).Magnitude <= 7 then
                                    task.wait(math.random(5, 15) / 100)
                                    safeFireTouch(hrp, targetBahan)
                                end
                            else
                                if cfg.SmartReroll and LabState.CurrentRerolls < 3 then
                                    LabState.NeededEggs = {}
                                end
                            end

                        elseif hasEgg and cfg.AutoDepositRawEgg then
                            LabState.CurrentTask = "Menyetorkan Telur ke Lab..."
                            humanoid:MoveTo(mainPart.Position)

                            if (hrp.Position - mainPart.Position).Magnitude <= 12 then
                                table.remove(LabState.NeededEggs, 1)
                                if #LabState.NeededEggs == 0 then
                                    LabState.CurrentRerolls = 0
                                end
                                task.wait(0.8)
                            end
                        end

                        labInfo.Text = string.format(
                            "Task: %s\nTarget Telur: %s\nGulung Ulang: %d/3",
                            LabState.CurrentTask or "Idle",
                            LabState.NeededEggs[1] or "Memindai...",
                            LabState.CurrentRerolls or 0
                        )
                    end
                end

            -- ========== STEAL MAP ==========
            elseif cfg.AutoStealMap and not cfg.ChaseActive then
                if hasEgg and cfg.AutoReturnBase then
                    local basePos = getPlayerBasePosition()
                    humanoid:MoveTo(basePos)
                else
                    local targetEgg = findEggInMap()
                    if targetEgg then
                        humanoid:MoveTo(targetEgg.Position)
                        if (hrp.Position - targetEgg.Position).Magnitude <= 7 then
                            task.wait(math.random(5, 15) / 100)
                            safeFireTouch(hrp, targetEgg)
                        end
                    end
                end
            end

            -- ========== MOVEMENT ==========
            if humanoid.WalkSpeed \~= cfg.WalkSpeed then
                humanoid.WalkSpeed = cfg.WalkSpeed
            end

            -- JumpHeight (modern) + JumpPower fallback
            pcall(function()
                if humanoid.UseJumpPower then
                    if humanoid.JumpPower \~= cfg.JumpPower then
                        humanoid.JumpPower = cfg.JumpPower
                    end
                else
                    local targetHeight = cfg.JumpPower * 0.3
                    if humanoid.JumpHeight \~= targetHeight then
                        humanoid.JumpHeight = targetHeight
                    end
                end
            end)

            if cfg.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            if cfg.Noclip then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            -- ========== GRAPHICS ==========
            if cfg.FullBright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
            end

            if cfg.PotatoGraphics then
                pcall(function()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end)
            end
        end)
    end
end)

print("SUCCESS: REY HUB | BETA [COMBO ANTI-KICK] Loaded Successfully!")
