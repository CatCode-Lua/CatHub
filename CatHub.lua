-- Crear ScreenGui
local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "SpeedFlyNoclipHub"

-- Crear Frame principal (tamaño relativo para móvil)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0.35, 0, 0.3, 0) -- porcentaje de la pantalla
Frame.Position = UDim2.new(0.325, 0, 0.35, 0) -- centrado
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.AnchorPoint = Vector2.new(0,0)
Frame.Name = "MainFrame"
local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 15)

-- Función para crear botones grandes y táctiles
local function createButton(name, yScale)
    local btn = Instance.new("TextButton")
    btn.Parent = Frame
    btn.Size = UDim2.new(0.9, 0, 0.2, 0) -- ancho 90%, altura 20% del frame
    btn.Position = UDim2.new(0.05, 0, yScale, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.AutoButtonColor = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    -- Efecto hover para PC (en móvil no hace nada)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    end)

    return btn
end

-- Crear botones
local SpeedButton = createButton("Activar Speed", 0.05)
local FlyButton = createButton("Activar Fly", 0.35)
local NoclipButton = createButton("Activar Noclip", 0.65)

-- Variables
local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
local flying = false
local noclip = false

-- Función Speed
SpeedButton.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = 50
        print("Speed activado")
    end
end)

-- Función Fly
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if flying and hrp then
        print("Fly activado")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0,50,0)
        bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.Parent = hrp
    elseif hrp then
        print("Fly desactivado")
        local bv = hrp:FindFirstChild("FlyVelocity")
        if bv then bv:Destroy() end
    end
end)

-- Función Noclip
NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    print("Noclip " .. (noclip and "activado" or "desactivado"))
end)

-- Loop Noclip
game:GetService("RunService").Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)