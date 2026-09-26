--[[
    ===================================================================
    PROJECT: REY HUB | BETA (STEAL AN EGG - RAW EGG LAB AFK)
    GAME: Steal An Egg (Roblox)
    OPTIMIZATION: Smart UI Scanner, Auto Reroll, Direct Raw Egg Deposit
    ===================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK Pintar (Mencegah Kicked saat AFK Berjam-jam)
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end)

-- Pemantau FPS Real-Time
local currentFPS = 60
local frameTimes = {}
RunService.RenderStepped:Connect(function(dt)
    table.insert(frameTimes, dt)
    if #frameTimes > 30 then table.remove(frameTimes, 1) end
    local total = 0
    for _, t in ipairs(frameTimes) do total = total + t end
    currentFPS = math.floor(30 / total)
end)

-- Konfigurasi Global 
getgenv().ReyHubConfig = {
    -- 🧬 DR. SCRAMBLE LAB (TELUR MENTAHAN)
    AutoLabAFK = false,
    TargetExperimental = true, 
    TargetBiohazard = true,
    TargetUnstableDNA = true,
    SmartReroll = true,        
    AutoDepositRawEgg = true,  -- Curi -> Langsung Setor Telur Mentah ke Lab
    
    -- 🥚 STEAL MAP
    AutoStealMap = false,
    SelectedBiome = "Forest", 
    TargetRarity = "Divine",
    AutoReturnBase = true,
    
    -- 🎯 PVP CHASE
    AutoChasePlayer = false,
    TargetPlayerName = "None",
    ChaseActive = false,
    
    -- 🐾 HATCH & SELL
    AutoHatch = false,
    AutoEquipBest = true,
    AutoSellEgg = false,
    SellEggCategory = "Common",
    
    -- ⚡ MOVEMENT
    AutoTreadmill = false,
    WalkSpeed = 45, 
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    
    -- 🌐 SERVER HOP
    AutoServerHop = false,
    MaxServerPlayers = 3,
    
    -- ⚙️ SETTINGS & ESP
    EspEggs = true,
    CustomFPSTarget = 60,
    PotatoGraphics = false,
    DisableShadows = true,
    FullBright = true
}

-- Variabel Internal Lab
local LabState = {
    NeededEggs = {},
    CurrentRerolls = 0,
    CurrentTask = "Idle" 
}

if CoreGui:FindFirstChild("ReyHubBeta") then
    CoreGui.ReyHubBeta:Destroy()
end

-- ==========================================
-- PEMBUATAN UI MODERN BERSIH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHubBeta"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 10) UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.Size = UDim2.new(1, 0, 0, 40)
local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 10) TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ REY HUB | BETA [RAW EGG LAB]"
Title.TextColor3 = Color3.fromRGB(150, 255, 50)
Title.TextSize = 12

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -11)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
local CloseC = Instance.new("UICorner") CloseC.CornerRadius = UDim.new(0, 4) CloseC.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(0, 130, 1, -40)
TabBar.CanvasSize = UDim2.new(0, 0, 2.5, 0)
TabBar.ScrollBarThickness = 2
local TabList = Instance.new("UIListLayout") TabList.Parent = TabBar TabList.Padding = UDim.new(0, 4)

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
    local list = Instance.new("UIListLayout") list.Parent = sf list.Padding = UDim.new(0, 6)
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
        for _, p in pairs(pages) do p.Visible = false end
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
    btn.TextSize, btn.TextXAlignment = 10, Enum.TextXAlignment.Left
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
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
    btn.TextSize, btn.TextXAlignment = 10, Enum.TextXAlignment.Left
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    local idx = 1
    for i, v in ipairs(options) do if v == getgenv().ReyHubConfig[key] then idx = i end end
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            idx = idx + 1 if idx > #options then idx = 1 end
            local chosen = options[idx]
            getgenv().ReyHubConfig[key] = chosen
            btn.Text = "  " .. name .. " [" .. tostring(chosen) .. "]"
        end)
    end)
end

-- ==========================================
-- MENU KONTEN
-- ==========================================

-- TAB 1: DR. SCRAMBLE LAB (RAW EGG DIRECT DEPOSIT)
local labInfo = Instance.new("TextLabel")
labInfo.Parent = pLab
labInfo.BackgroundTransparency = 1
labInfo.Size = UDim2.new(1, 0, 0, 55)
labInfo.Font = Enum.Font.Gotham
labInfo.Text = "Task: Idle\nTarget Telur: Memindai...\nGulung Ulang: 0/3"
labInfo.TextColor3 = Color3.fromRGB(150, 255, 50)
labInfo.TextSize = 11

addToggle(pLab, "▶️ AKTIFKAN FULL AFK LAB (MENTAHAN)", "AutoLabAFK")
addToggle(pLab, "Incar Mutasi: Experimental Pets", "TargetExperimental")
addToggle(pLab, "Incar Mutasi: Biohazard Pets", "TargetBiohazard")
addToggle(pLab, "Incar Mutasi: Unstable DNA", "TargetUnstableDNA")
addToggle(pLab, "Smart Reroll (Max 3x Gratis)", "SmartReroll")
addToggle(pLab, "Auto Curi -> Langsung Setor ke Lab", "AutoDepositRawEgg")

-- TAB 2: STEAL MAP
addToggle(pSteal, "Jalan Otomatis Curi Telur", "AutoStealMap")
addSelector(pSteal, "Pilih Biome Map", {"Forest", "Lake", "Desert", "Jungle", "Cherry Blossom", "Snow", "Volcano", "Abyss", "Angels & Demons"}, "SelectedBiome")
addSelector(pSteal, "Target Rarity Telur", {"Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Eternal", "Kosmik", "Secret"}, "TargetRarity")
addToggle(pSteal, "Lari Balik Ke Base Jika Dapat", "AutoReturnBase")
addToggle(pSteal, "ESP Radar Telur di Map", "EspEggs")

-- TAB 3: PVP CHASE
addToggle(pSniper, "Auto Kejar Semua Target Bawa Telur", "AutoChasePlayer")

-- TAB 4: HATCH & SELL
addToggle(pHatch, "Auto Hatch Eggs (Manual Hatch)", "AutoHatch")
addToggle(pHatch, "Auto Equip Best Pets", "AutoEquipBest")
addToggle(pHatch, "Auto Sell Egg (Jual Telur)", "AutoSellEgg")
addSelector(pHatch, "Kategori Jual Rarity", {"Common", "Rare", "Epic", "Legendary", "Mythic"}, "SellEggCategory")

-- TAB 5: MOVEMENT
addToggle(pMove, "Lari Otomatis di Treadmill", "AutoTreadmill")
addSelector(pMove, "WalkSpeed Lari", {16, 30, 45, 60, 80}, "WalkSpeed")
addToggle(pMove, "Infinite Jump (Terbang)", "InfiniteJump")
addToggle(pMove, "Noclip (Tembus Tembok)", "Noclip")

-- TAB 6: SERVER HOP
addToggle(pHop, "Aktifkan Auto Server Hop", "AutoServerHop")
addSelector(pHop, "Max Player per Server", {1, 2, 3, 4, 5, 6, 7}, "MaxServerPlayers")

-- TAB 7: SETTINGS
addSelector(pSettings, "Target Batas FPS", {30, 60, 120, 240}, "CustomFPSTarget")
addToggle(pSettings, "Potato Graphics", "PotatoGraphics")
addToggle(pSettings, "FullBright", "FullBright")

-- ==========================================
-- ENGINE: SMART AI & NATURAL WALKING
-- ==========================================

local function getPlayerBasePosition()
    local pos = Vector3.new(0, 10, 0) 
    pcall(function()
        local bases = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Tycoons")
        if bases then
            for _, b in pairs(bases:GetChildren()) do
                if tostring(b.Owner.Value) == LocalPlayer.Name or b.Name == LocalPlayer.Name then
                    pos = b:FindFirstChild("Dropoff").Position or b:FindFirstChild("SpawnLocation").Position
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
                if v:IsA("TextLabel") and v.Text:lower():match("telur") and not v.Text:match("/") then
                    table.insert(needed, v.Text)
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
                    firesignal(v.MouseButton1Click)
                    task.wait(1)
                end
            end
        end
    end)
end

local function findEggInMap(specificName)
    local targetEgg = nil
    pcall(function()
        local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("MapEggs")
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

-- MAIN ENGINE LOOP
task.spawn(function()
    while true do
        local adaptiveDelay = (currentFPS < 22) and 0.5 or 0.1
        task.wait(adaptiveDelay)
        
        pcall(function()
            local cfg = getgenv().ReyHubConfig
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            if setfpscap then setfpscap(cfg.CustomFPSTarget) end
            
            if hrp and humanoid then
                local hasEgg = char:FindFirstChild("Egg") or char:FindFirstChild("CarriedEgg") or char:FindFirstChildOfClass("Tool")
                
                -- =============================================
                -- LOGIKA 1: FULL AFK DR. SCRAMBLE LAB (RAW EGG)
                -- =============================================
                if cfg.AutoLabAFK then
                    local labMachine = Workspace:FindFirstChild("DrScrambleLab") or Workspace:FindFirstChild("Laboratory")
                    
                    if labMachine then
                        -- Step 1: Scan apa yang dibutuhkan Lab
                        if #LabState.NeededEggs == 0 then
                            LabState.CurrentTask = "Scanning UI..."
                            humanoid:MoveTo(labMachine:FindFirstChild("MainPart").Position)
                            
                            if (hrp.Position - labMachine:FindFirstChild("MainPart").Position).Magnitude <= 10 then
                                local scanned = scanDrScrambleUI()
                                if #scanned > 0 then
                                    if cfg.SmartReroll and LabState.CurrentRerolls < 3 then
                                        -- Cek jika telur tidak ada di map, reroll
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
                            
                        -- Step 2: Curi Telur Mentah yang Sesuai
                        elseif #LabState.NeededEggs > 0 and not hasEgg then
                            LabState.CurrentTask = "Mencari telur mentah: " .. LabState.NeededEggs[1]
                            local targetBahan = findEggInMap(LabState.NeededEggs[1])
                            if targetBahan then
                                humanoid:MoveTo(targetBahan.Position)
                                if (hrp.Position - targetBahan.Position).Magnitude <= 6 then
                                    firetouchinterest(hrp, targetBahan, 0)
                                    task.wait(0.1)
                                    firetouchinterest(hrp, targetBahan, 1)
                                end
                            else
                                -- Jika telur tidak ditemukan saat dicari, coba reroll
                                if cfg.SmartReroll and LabState.CurrentRerolls < 3 then
                                    LabState.NeededEggs = {} -- Reset trigger scan ulang
                                end
                            end
                            
                        -- Step 3: Bawa Telur Mentah Langsung ke Lab
                        elseif hasEgg and cfg.AutoDepositRawEgg then
                            LabState.CurrentTask = "Menyetorkan Telur Mentah ke Lab..."
                            humanoid:MoveTo(labMachine:FindFirstChild("MainPart").Position)
                            
                            if (hrp.Position - labMachine:FindFirstChild("MainPart").Position).Magnitude <= 10 then
                                pcall(function()
                                    -- Bypass simulasi klik "Tambah" di Lab
                                    -- Dalam game, biasanya ada prompt kedekatan (proximity prompt) atau touch GUI
                                    table.remove(LabState.NeededEggs, 1) -- Centang bahwa 1 telur sudah disetor
                                    if #LabState.NeededEggs == 0 then
                                        LabState.CurrentRerolls = 0 -- Reset reroll setelah cycle penuh
                                    end
                                end)
                            end
                        end
                        
                        labInfo.Text = string.format("Task: %s\nTarget Telur: %s\nGulung Ulang: %d/3", 
                            LabState.CurrentTask, 
                            (LabState.NeededEggs[1] or "Memindai..."), 
                            LabState.CurrentRerolls)
                    end
                    
                -- =============================================
                -- LOGIKA 2: AUTO STEAL MAP BIASA
                -- =============================================
                elseif cfg.AutoStealMap and not cfg.ChaseActive then
                    if hasEgg and cfg.AutoReturnBase then
                        local basePos = getPlayerBasePosition()
                        humanoid:MoveTo(basePos)
                    else
                        local targetEgg = findEggInMap()
                        if targetEgg then
                            humanoid:MoveTo(targetEgg.Position)
                            if (hrp.Position - targetEgg.Position).Magnitude <= 6 then
                                firetouchinterest(hrp, targetEgg, 0)
                                task.wait(0.1)
                                firetouchinterest(hrp, targetEgg, 1)
                            end
                        end
                    end
                end
                
                -- Terapan Movement
                humanoid.WalkSpeed = cfg.WalkSpeed
                humanoid.JumpPower = cfg.JumpPower
                if cfg.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                if cfg.Noclip then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
            
            if cfg.FullBright then Lighting.Brightness = 2 Lighting.ClockTime = 14 end
            if cfg.PotatoGraphics then pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) end
        end)
    end
end)

print("SUCCESS: REY HUB | BETA [SMART LAB RAW EGG AFK] Loaded Successfully!")
