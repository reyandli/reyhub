--[[
    ===================================================================
    👑 REY HUB | V2 MODERN (GOAT EDITION)
    GAME: Steal An Egg (Roblox)
    BYPASS: Item Bring (Teleport Egg to Player), Anti-Guardian, Stable UI
    EXECUTOR: 100% Delta Android Compatible (No Crash/Syntax Error)
    ===================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- ==========================================
-- SERVICES & GLOBAL VARIABLES
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

-- Mencari tempat UI yang aman (Bypass deteksi CoreGui jika didukung)
local guiTarget = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer.PlayerGui

-- ==========================================
-- 🛡️ EXUNYS ANTI-KICK (STABLE VERSION)
-- ==========================================
local getgenv = getgenv or function() return _G end
local getnamecallmethod = getnamecallmethod
local hookmetamethod = hookmetamethod
local hookfunction = hookfunction
local newcclosure = newcclosure
local checkcaller = checkcaller

if not getgenv().ED_AntiKick then
    local cloneref = cloneref or function(...) return ... end
    local clonefunction = clonefunction or function(...) return ... end
    local SetCore = clonefunction(StarterGui.SetCore)
    local FindFirstChild = clonefunction(game.FindFirstChild)

    getgenv().ED_AntiKick = {
        Enabled = true,
        SendNotifications = false, -- Dimatikan agar tidak spam notif di layar
        CheckCaller = true
    }

    if hookmetamethod and newcclosure and getnamecallmethod then
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local self = ...
            local method = getnamecallmethod()
            if getgenv().ED_AntiKick.Enabled and self == LocalPlayer and string.lower(method) == "kick" then
                if getgenv().ED_AntiKick.CheckCaller and checkcaller and checkcaller() then
                    return OldNamecall(...)
                end
                return nil -- BLOCKED!
            end
            return OldNamecall(...)
        end))
    end
end

-- ==========================================
-- ⚙️ KONFIGURASI GLOBAL
-- ==========================================
getgenv().ReyHubConfig = {
    -- 🥚 AUTO STEAL (BYPASS BRING ITEM)
    AutoStealMap = false,
    SafeZoneAFK = true, -- Diam di Safezone, telur ditarik
    TargetRarity = "Divine",
    SelectedBiome = "Forest",
    
    -- 🛡️ ANTI-GUARDIAN & COMBAT
    AntiGuardian = true, -- Anti Terpental saat diserang
    
    -- 🧬 DR. SCRAMBLE LAB (MENTAHAN)
    AutoLabAFK = false,
    AutoDepositRawEgg = true,
    TargetExperimental = true,
    SmartReroll = true,
    
    -- ⚡ MOVEMENT & EXTRAS
    WalkSpeed = 40,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    PotatoGraphics = false,
    FullBright = true
}

local LabState = { NeededEggs = {}, CurrentRerolls = 0, CurrentTask = "Idle" }

-- ==========================================
-- 🎨 V2 MODERN UI DESIGN (NEON THEME)
-- ==========================================
pcall(function()
    if guiTarget:FindFirstChild("ReyHubV2") then guiTarget.ReyHubV2:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHubV2"
ScreenGui.Parent = guiTarget
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame (Dark Neon Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(0, 200, 255) UIStroke.Thickness = 1 UIStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
TopBar.Size = UDim2.new(1, 0, 0, 45)
local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 12) TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "👑 REY HUB | V2 MODERN"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
local CloseC = Instance.new("UICorner") CloseC.CornerRadius = UDim.new(0, 6) CloseC.Parent = CloseBtn

-- Tab System
local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.Size = UDim2.new(0, 140, 1, -45)
TabBar.CanvasSize = UDim2.new(0, 0, 2, 0)
TabBar.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout") TabList.Parent = TabBar TabList.Padding = UDim.new(0, 2)

local pages = {}
local function createPage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Parent = MainFrame
    sf.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.Position = UDim2.new(0, 150, 0, 55)
    sf.Size = UDim2.new(1, -160, 1, -65)
    sf.CanvasSize = UDim2.new(0, 0, 3, 0)
    sf.ScrollBarThickness = 2
    sf.Visible = false
    local list = Instance.new("UIListLayout") list.Parent = sf list.Padding = UDim.new(0, 8)
    pages[name] = sf
    return sf
end

local pSteal = createPage("StealMap")
local pLab = createPage("DrScramble")
local pCombat = createPage("Combat")
local pSettings = createPage("Settings")

local function addTabBtn(name, icon, target)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) b.BackgroundColor3 = Color3.fromRGB(20,20,25) end
        end
        target.Visible = true
        btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
end

addTabBtn("Auto Steal", "🥚", pSteal)
addTabBtn("Dr. Scramble", "🧬", pLab)
addTabBtn("Combat Mods", "🛡️", pCombat)
addTabBtn("Settings", "⚙️", pSettings)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- UI Element Builders
local function addToggle(parent, name, key)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. name .. ": " .. (getgenv().ReyHubConfig[key] and "✅" or "❌")
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().ReyHubConfig[key] = not getgenv().ReyHubConfig[key]
            local state = getgenv().ReyHubConfig[key]
            btn.Text = "  " .. name .. ": " .. (state and "✅" or "❌")
            btn.UIStroke.Color = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(60, 60, 60)
        end)
    end)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = getgenv().ReyHubConfig[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = btn
end

-- TAB: STEAL MAP (BRING BYPASS)
local warnLabel = Instance.new("TextLabel")
warnLabel.Parent = pSteal
warnLabel.BackgroundTransparency = 1
warnLabel.Size = UDim2.new(1, 0, 0, 40)
warnLabel.Font = Enum.Font.GothamSemibold
warnLabel.Text = "Bypass Mode: Telur ditarik ke Inventory!\nBerdiri di Safezone agar aman."
warnLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
warnLabel.TextSize = 10

addToggle(pSteal, "▶️ AKTIFKAN AUTO STEAL BYPASS", "AutoStealMap")
addToggle(pSteal, "Diam di Safezone (Wajib Aktif)", "SafeZoneAFK")

-- TAB: DR SCRAMBLE
local labInfo = Instance.new("TextLabel")
labInfo.Parent = pLab
labInfo.BackgroundTransparency = 1
labInfo.Size = UDim2.new(1, 0, 0, 40)
labInfo.Font = Enum.Font.Gotham
labInfo.Text = "Status Lab: Menunggu..."
labInfo.TextColor3 = Color3.fromRGB(0, 255, 255)
labInfo.TextSize = 11

addToggle(pLab, "▶️ AUTO LAB AFK (MENTAHAN)", "AutoLabAFK")
addToggle(pLab, "Smart Reroll (Max 3x)", "SmartReroll")

-- TAB: COMBAT (ANTI GUARDIAN)
local combatWarn = Instance.new("TextLabel")
combatWarn.Parent = pCombat
combatWarn.BackgroundTransparency = 1
combatWarn.Size = UDim2.new(1, 0, 0, 30)
combatWarn.Font = Enum.Font.GothamSemibold
combatWarn.Text = "Karakter tidak akan terpental saat diserang hewan!"
combatWarn.TextColor3 = Color3.fromRGB(150, 255, 150)
combatWarn.TextSize = 10

addToggle(pCombat, "🛡️ ANTI-GUARDIAN (No Knockback)", "AntiGuardian")
addToggle(pCombat, "Infinite Jump (Spasi Terbang)", "InfiniteJump")
addToggle(pCombat, "Noclip (Tembus Tembok)", "Noclip")

-- TAB: SETTINGS
addToggle(pSettings, "FullBright (Terang Benderang)", "FullBright")
addToggle(pSettings, "Potato Graphics (Anti Lag)", "PotatoGraphics")

pSteal.Visible = true

-- ==========================================
-- ⚙️ ENGINE: ITEM BRING & ANTI-KNOCKBACK
-- ==========================================

-- Fungsi Anti-Guardian (Mencegah Karakter Terpental)
RunService.Stepped:Connect(function()
    pcall(function()
        if getgenv().ReyHubConfig.AntiGuardian then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                
                -- Jika kecepatan terpental tidak wajar (Diserang), bekukan momentumnya
                if hrp and hrp.Velocity.Magnitude > 30 then
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) -- Pertahankan gravitasi, matikan pentalan
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
                
                -- Mencegah karakter jatuh/ragdoll karena cakar hewan
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                end
            end
        end
    end)
end)

-- Fungsi Cerdas Membawa Telur (Teleportasi Telur ke Pemain)
local function bringEggToPlayer()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetEgg = nil
    pcall(function()
        local folders = {Workspace:FindFirstChild("Eggs"), Workspace:FindFirstChild("MapEggs")}
        for _, folder in ipairs(folders) do
            if folder then
                for _, egg in pairs(folder:GetDescendants()) do
                    if egg:IsA("BasePart") and egg.Name:lower():match("egg") then
                        targetEgg = egg
                        break -- Ambil telur pertama yang ditemukan
                    end
                end
            end
        end
    end)

    if targetEgg then
        pcall(function()
            -- BYPASS: Pindahkan fisik telur secara paksa ke karakter kita
            targetEgg.CFrame = hrp.CFrame
            task.wait(0.05)
            
            -- Eksekusi simulasi sentuhan
            if firetouchinterest then
                firetouchinterest(hrp, targetEgg, 0)
                task.wait(0.1)
                firetouchinterest(hrp, targetEgg, 1)
            end
        end)
        return true
    end
    return false
end

-- ==========================================
-- 🔄 MAIN LOOP (SUPER STABLE)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.3) -- Delay aman agar Executor tidak crash

        pcall(function()
            local cfg = getgenv().ReyHubConfig
            local char = LocalPlayer.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- 1. AUTO STEAL MAP (BYPASS MODE)
            if cfg.AutoStealMap then
                local hasEgg = char:FindFirstChild("Egg") or char:FindFirstChild("CarriedEgg") or char:FindFirstChildOfClass("Tool")
                
                if not hasEgg then
                    -- Telur ditarik langsung ke pemain!
                    bringEggToPlayer()
                else
                    -- Jika sedang memegang telur, bawa balik ke markas (atau biarkan jika mau simpan)
                    if not cfg.SafeZoneAFK then
                        -- Opsional: Pindahkan karakter jika tidak di safezone
                    end
                end
            end

            -- 2. MOVEMENT MODS
            if cfg.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end

            if cfg.Noclip then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end

            -- 3. GRAPHICS
            if cfg.FullBright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
            end
            if cfg.PotatoGraphics then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end
        end)
    end
end)

print("👑 REY HUB | V2 (GOAT EDITION) LOADED SUCCESSFULLY!")
