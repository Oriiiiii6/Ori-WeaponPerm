Config = {}

Config.Framework = "qb" -- "qb" or "esx"

Config.DiscordGuildId = "Your_Guild_ID"
Config.AllowedRoleId = "Your_Role_ID"
Config.BotToken = "NOT TODAY" -- put in server.lua line : 1

Config.Locale = "en" -- en or he

Config.RefreshCheck  = '10'
Config.TimeUnit = 1000 -- 1000 = seconds , 60000 = minutes , 3600000 = hours

Config.Messages = {
    he = {
        NoPermission = "אין לך הרשאה להחזיק נשק",
        TitleCheck = "בדיקה",
        TitleWarn = 'אזהרה',
    },
    en = {
        NoPermission = "You don't have permission to carry a weapon",
        TitleCheck = "Checking",
        TitleWarn = 'Warning',
    }
}
