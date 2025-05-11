-- GUI Setup
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "CompactDanceGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.5, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local padding = 8
local spacing = 30

local function makeButton(name, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -padding * 2, 0, 24)
    btn.Position = UDim2.new(0, padding, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = frame
    return btn
end

-- Main Controls
local loadBtn = makeButton("Load Animator + Oxide", padding)
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -padding * 2, 0, 24)
input.Position = UDim2.new(0, padding, 0, padding + spacing)
input.PlaceholderText = "Enter Animation ID"
input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
input.TextSize = 13
input.ClearTextOnFocus = false
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

local stopBtn = makeButton("Stop Animation", padding + spacing * 2, Color3.fromRGB(255, 65, 65))
local toggleDances = makeButton("▼ Dances", padding + spacing * 3, Color3.fromRGB(60, 60, 60))

-- Dances Scroll Frame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -padding * 2, 0, spacing * 4)
scroll.Position = UDim2.new(0, padding, 0, padding)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scroll.ScrollBarThickness = 4
scroll.Visible = false
scroll.BorderSizePixel = 0
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Close Button for Dances Tab
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Visible = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Animator Logic
local AnimatorLoaded = false
local currentAnim = nil
local playingDanceId = nil

loadBtn.MouseButton1Click:Connect(function()
    if not AnimatorLoaded then
        if not getgenv()["Animator"] then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
        end
        -- Oxide settings
        _G.HideCharacter = true
        _G.FlingEnabled = true
        _G.TransparentRig = true
        _G.ToolFling = false
        _G.AntiFling = true -- changed to true
        _G.CustomHats = false
        _G.CH = {
            Torso = {Name = "Black", TextureId = "14251599953", Orientation = CFrame.Angles(0, 0, 0)},
            LeftArm = {Name = "Accessory (LARM)", TextureId = "17374768001", Orientation = CFrame.Angles(0, 0, math.rad(90))},
            RightArm = {Name = "Accessory (RARM)", TextureId = "17374768001", Orientation = CFrame.Angles(0, 0, math.rad(90))},
            LeftLeg = {Name = "Accessory (LLeg)", TextureId = "17387586304", Orientation = CFrame.Angles(0, 0, math.rad(90))},
            RightLeg = {Name = "Accessory (rightleg)", TextureId = "17387586304", Orientation = CFrame.Angles(0, 0, math.rad(90))}
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nitro-GT/Oxide/refs/heads/main/LoadstringPerma"))()
        task.wait(0.5)
        AnimatorLoaded = true
        loadBtn.Text = "Loaded!"
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

input.FocusLost:Connect(function(enterPressed)
    if enterPressed and AnimatorLoaded then
        local id = tonumber(input.Text)
        if id then
            local Player = game:GetService("Players").LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            if currentAnim then currentAnim:Stop() end
            currentAnim = Animator.new(Character, id)
            currentAnim:Play()
            playingDanceId = id
        else
            warn("Invalid animation ID")
        end
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
        playingDanceId = nil
    end
end)

toggleDances.MouseButton1Click:Connect(function()
    local open = not scroll.Visible
    scroll.Visible = open
    closeBtn.Visible = open
    toggleDances.Text = open and "▲ Dances" or "▼ Dances"
    loadBtn.Visible = not open
    input.Visible = not open
    stopBtn.Visible = not open
end)

closeBtn.MouseButton1Click:Connect(function()
    scroll.Visible = false
    closeBtn.Visible = false
    toggleDances.Text = "▼ Dances"
    loadBtn.Visible = true
    input.Visible = true
    stopBtn.Visible = true
end)

-- Dances
local dances = {
    {Name = "Jumpstyle", Id = 15304868210},
    {Name = "Chill", Id = 103112841595182},
    {Name = "Teto Dance", Id = 99703499782716},
    {Name = "Popipo", Id = 78991327797272},
    {Name = "Egypt Dance", Id = 95986135548450},
    {Name = "Sit", Id = 77436653907705},
    {Name = "Two", Id = 137845929482571},
    {Name = "Chill 2", Id = 123679396001353},
}

for _, dance in pairs(dances) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -4, 0, 24)
    btn.Text = dance.Name
    btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.LayoutOrder = _
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        if currentAnim and playingDanceId == dance.Id then
            currentAnim:Stop()
            currentAnim = nil
            playingDanceId = nil
        else
            if currentAnim then currentAnim:Stop() end
            currentAnim = Animator.new(Character, dance.Id)
            currentAnim:Play()
            playingDanceId = dance.Id
        end
    end)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)