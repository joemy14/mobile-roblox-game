-- File: ReplicatedStorage/Modules/WeaponData.lua
-- ModuleScript containing stats for the 4 Survivor Kits.
-- Used by both Server (validation/damage calc) and Client (UI/Preview).

--!strict

-- Define the structure for a Weapon/Kit data entry
export type WeaponData = {
	Name: string,
	Description: string,
	Damage: number,
	Knockback: number, -- Studs of force applied to enemies
	Range: number, -- Studs (Melee reach or Projectile max distance)
	Cooldown: number, -- Seconds between attacks/uses
	IsMelee: boolean,
	AnimationId: string, -- Roblox Asset ID for the attack animation
	SoundId: string, -- Roblox Asset ID for the attack sound
	VisualEffect: string?, -- Key for VFX system (e.g., "RedCross_BandageToss")
}

local WeaponData: { [string]: WeaponData } = {
	["RedCross"] = {
		Name = "Red Cross Medic Kit",
		Description = "Heals allies and purges corruption with blessed bandages. Moderate range, low damage, high utility.",
		Damage = 5, -- Low direct damage, high "Purge" effect vs corruption
		Knockback = 4,
		Range = 12, -- Ranged throw
		Cooldown = 1.5,
		IsMelee = false,
		AnimationId = "rbxassetid://0000000000", -- Placeholder: Throw animation
		SoundId = "rbxassetid://0000000000", -- Placeholder: Whoosh/Wrap sound
		VisualEffect = "RedCross_BandageProjectile",
	},

	["Skater"] = {
		Name = "Skater's Deck",
		Description = "High mobility melee kit. Uses a customized board for wide sweeping knockback. Fast attacks, low single-target damage.",
		Damage = 12,
		Knockback = 18, -- High crowd control
		Range = 6, -- Melee sweep range
		Cooldown = 0.6,
		IsMelee = true,
		AnimationId = "rbxassetid://0000000000", -- Placeholder: Board swing animation
		SoundId = "rbxassetid://0000000000", -- Placeholder: Wood impact sound
		VisualEffect = "Skater_BoardTrail",
	},

	["Tanod"] = {
		Name = "Tanod's Baton & Whistle",
		Description = "Barangay peacekeeper kit. Stuns enemies with whistle (AoE) and strikes with baton. Balanced stats, authority aura.",
		Damage = 18,
		Knockback = 10,
		Range = 5, -- Melee
		Cooldown = 1.0,
		IsMelee = true,
		AnimationId = "rbxassetid://0000000000", -- Placeholder: Baton strike + Whistle blow
		SoundId = "rbxassetid://0000000000", -- Placeholder: Whistle + Thud
		VisualEffect = "Tanod_WhistleWave",
	},

	["OldMan"] = {
		Name = "Lolo's Walking Stick",
		Description = "Elder wisdom kit. Channels 'Usog' (curse) to slow enemies and deal delayed burst damage. High range via projection.",
		Damage = 25, -- Delayed burst
		Knockback = 2,
		Range = 15, -- Projectile/Curse range
		Cooldown = 2.2,
		IsMelee = false,
		AnimationId = "rbxassetid://0000000000", -- Placeholder: Staff slam / Point
		SoundId = "rbxassetid://0000000000", -- Placeholder: Mystical hum
		VisualEffect = "OldMan_CurseProjectile",
	},
}

-- Helper to safely retrieve data with a fallback warning
local function GetWeaponData(kitName: string): WeaponData
	local data = WeaponData[kitName]
	if not data then
		warn(`[WeaponData] Kit '{kitName}' not found. Falling back to RedCross.`)
		return WeaponData["RedCross"]
	end
	return data
end

return {
	Data = WeaponData,
	Get = GetWeaponData,
}


-- File: ReplicatedStorage/Modules/EnemyData.lua
-- ModuleScript containing stats for all Enemy Types (Engkanto).
-- Used by Spawner (Server), AI Controllers (Server), and UI Bestiary (Client).

--!strict

-- Define the structure for an Enemy data entry
export type EnemyData = {
	Name: string,
	Description: string,
	Health: number,
	WalkSpeed: number, -- Studs per second
	Damage: number, -- Damage per hit to Player/Objective
	SpecialAbilityCooldown: number, -- Seconds between special ability usage
	SizeScale: number, -- Uniform scale factor for the Model (1.0 = default)
	AnimationIds: { -- Keys for AnimationController
		Idle: string,
		Walk: string,
		Attack: string,
		Special: string,
		Stun: string,
		Death: string, -- Non-lethal "Banish/Dispel" animation
	},
	SoundIds: { -- Keys for SoundService/VFX
		Spawn: string,
		Attack: string,
		Special: string,
		Hit: string,
		Banish: string,
	},
	VisualProfile: string, -- Key for Material/Color palette (e.g., "Horde_Standard")
}

local EnemyData: { [string]: EnemyData } = {
	["CommonHorde"] = {
		Name = "Lost Soul (Horde)",
		Description = "Common villagers overwhelmed by the 'Ubo'. Weak individually, dangerous in numbers. No special ability.",
		Health = 50,
		WalkSpeed = 10,
		Damage = 5,
		SpecialAbilityCooldown = math.huge, -- No special ability
		SizeScale = 1.0,
		AnimationIds = {
			Idle = "rbxassetid://0000000000",
			Walk = "rbxassetid://0000000000",
			Attack = "rbxassetid://0000000000",
			Special = "",
			Stun = "rbxassetid://0000000000",
			Death = "rbxassetid://0000000000",
		},
		SoundIds = {
			Spawn = "rbxassetid://0000000000",
			Attack = "rbxassetid://0000000000",
			Special = "",
			Hit = "rbxassetid://0000000000",
			Banish = "rbxassetid://0000000000",
		},
		VisualProfile = "Horde_Standard",
	},

	["Tiyanak"] = {
		Name = "Tiyanak (The Pouncer)",
		Description = "Mimics a crying baby to lure survivors. Pounces from ceilings/walls to isolate targets. High burst, low health.",
		Health = 80,
		WalkSpeed = 14, -- Fast ground speed
		Damage = 20,
		SpecialAbilityCooldown = 8.0,
		SizeScale = 0.8,
		AnimationIds = {
			Idle = "rbxassetid://0000000000", -- Crawling/Crouched
			Walk = "rbxassetid://0000000000", -- Scuttling
			Attack = "rbxassetid://0000000000", -- Swipe
			Special = "rbxassetid://0000000000", -- Pounce/Leap
			Stun = "rbxassetid://0000000000",
			Death = "rbxassetid://0000000000",
		},
		SoundIds = {
			Spawn = "rbxassetid://0000000000", -- Distorted crying
			Attack = "rbxassetid://0000000000",
			Special = "rbxassetid://0000000000", -- Screech before pounce
			Hit = "rbxassetid://0000000000",
			Banish = "rbxassetid://0000000000",
		},
		VisualProfile = "Tiyanak_Pale",
	},

	["Kapre"] = {
		Name = "Kapre (The Puller)",
		Description = "Giant tree-dweller. Uses a spectral vine/chain to pull survivors out of position into the horde. Tanky, slow.",
		Health = 400,
		WalkSpeed = 6,
		Damage = 15,
		SpecialAbilityCooldown = 12.0,
		SizeScale = 2.5,
		AnimationIds = {
			Idle = "rbxassetid://0000000000", -- Leaning on tree
			Walk = "rbxassetid://0000000000", -- Heavy lumbering
			Attack = "rbxassetid://0000000000", -- Ground slam
			Special = "rbxassetid://0000000000", -- Vine launch / Reel
			Stun = "rbxassetid://0000000000", -- Kneeling
			Death = "rbxassetid://0000000000", -- Fading into smoke
		},
		SoundIds = {
			Spawn = "rbxassetid://0000000000", -- Deep tobacco cough
			Attack = "rbxassetid://0000000000",
			Special = "rbxassetid://0000000000", -- Vine whoosh
			Hit = "rbxassetid://0000000000",
			Banish = "rbxassetid://0000000000",
		},
		VisualProfile = "Kapre_DarkBark",
	},

	["Tikbalang"] = {
		Name = "Tikbalang (The Charger)",
		Description = "Horse-headed trickster. Charges in a straight line, knocking down everything in path. Disorients survivors (screen shake/blur).",
		Health = 250,
		WalkSpeed = 12,
		Damage = 30,
		SpecialAbilityCooldown = 10.0,
		SizeScale = 1.8,
		AnimationIds = {
			Idle = "rbxassetid://0000000000", -- Pawing ground
			Walk = "rbxassetid://0000000000", -- Trotting
			Attack = "rbxassetid://0000000000", -- Kick/Stomp
			Special = "rbxassetid://0000000000", -- Charge windup/release
			Stun = "rbxassetid://0000000000", -- Dizzy/Head shake
			Death = "rbxassetid://0000000000", -- Rearing up then fading
		},
		SoundIds = {
			Spawn = "rbxassetid://0000000000", -- Loud Neigh
			Attack = "rbxassetid://0000000000",
			Special = "rbxassetid://0000000000", -- Gallop sound buildup
			Hit = "rbxassetid://0000000000",
			Banish = "rbxassetid://0000000000",
		},
		VisualProfile = "Tikbalang_SmokeMane",
	},
}

-- Helper to safely retrieve data
local function GetEnemyData(enemyName: string): EnemyData
	local data = EnemyData[enemyName]
	if not data then
		warn(`[EnemyData] Enemy '{enemyName}' not found. Falling back to CommonHorde.`)
		return EnemyData["CommonHorde"]
	end
	return data
end

-- Helper to get a list of all spawnable enemy keys (for Wave Spawners)
local function GetSpawnableKeys(): { string }
	local keys = {}
	for key, _ in pairs(EnemyData) do
		table.insert(keys, key)
	end
	return keys
end

return {
	Data = EnemyData,
	Get = GetEnemyData,
	GetSpawnableKeys = GetSpawnableKeys,
}


-- TEST SCRIPT (Place in ServerScriptService/TestLoadData)
-- Run this once to verify ModuleScripts load and print correctly.
--[[
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local weaponModule = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeaponData")
local enemyModule = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EnemyData")

local WeaponData = require(weaponModule)
local EnemyData = require(enemyModule)

print("--- WEAPON DATA LOAD TEST ---")
for key, data in pairs(WeaponData.Data) do
	print(`Kit: {key} | DMG: {data.Damage} | Range: {data.Range} | Melee: {data.IsMelee}`)
end

print("\n--- ENEMY DATA LOAD TEST ---")
for key, data in pairs(EnemyData.Data) do
	print(`Enemy: {key} | HP: {data.Health} | SPD: {data.WalkSpeed} | Special CD: {data.SpecialAbilityCooldown}`)
end

-- Test Getters
local testKit = WeaponData.Get("Skater")
local testEnemy = EnemyData.Get("Kapre")
print(`\nGetter Test - Skater Cooldown: {testKit.Cooldown}`)
print(`Getter Test - Kapre Health: {testEnemy.Health}`)

print("\n[SUCCESS] All Data Modules loaded without errors.")
]]