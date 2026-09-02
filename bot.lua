local discord = require('discordia')
local client = discord.Client()

client:on('ready', function()
    print(string.format('Logged in as %s', client.user.username))
    client:setActivity('CodeVerse 24/7')
end)

client:on('messageCreate', function(message)
    if message.author.bot then return end

    local content = message.content
    local guild = message.guild
    local args = {}
    for word in content:gmatch("%S+") do
        table.insert(args, word)
    end
    local cmd = args[1]

    if cmd == '!ping' then
        message.channel:reply('Pong! 🏓 Bot Lua đang hoạt động mượt mà.')

    elseif cmd == '!help' then
        local embed = {
            title = "💻 CodeVerse Bot - Bảng Điều Khiển 💻",
            description = "Danh sách các lệnh của bot:",
            color = 0x5865F2,
            fields = {
                { name = "!ping", value = "Kiểm tra độ trễ bot", inline = true },
                { name = "!server", value = "Xem thông tin & thống kê server", inline = true },
                { name = "!link", value = "Lấy các đường dẫn liên kết", inline = true },
                { name = "!mute @user", value = "Tước quyền chat của thành viên", inline = false },
                { name = "!ban @user", value = "Cấm thành viên khỏi server", inline = false }
            },
            footer = { text = "Phát triển bởi @parotti" }
        }
        message.channel:reply({ embed = embed })

    elseif cmd == '!server' then
        if guild then
            local total_members = guild.totalMemberCount or "N/A"
            local total_channels = #guild.channels
            local total_roles = #guild.roles
            
            message.channel:reply(string.format(
                "📊 **Thống kê Server CodeVerse**\n" ..
                "- Tổng thành viên: %s\n" ..
                "- Tổng số kênh: %d\n" ..
                "- Tổng số vai trò (Roles): %d\n" ..
                "- Chủ sở hữu: @parotti",
                tostring(total_members), total_channels, total_roles
            ))
        else
            message.channel:reply("Lệnh này chỉ dùng được trong server!")
        end

    elseif cmd == '!link' then
        message.channel:reply("🔗 **Liên kết chính thức:**\n- Discord: https://discord.gg/Qp6fRCstjT\n- Link rút gọn: https://dsc.gg/code-verse\n- Guns.lol: https://guns.lol/parotti")

    elseif cmd == '!mute' then
        if not message.member:hasPermission('manageMessages') then
            message.channel:reply("❌ Bạn không có quyền sử dụng lệnh này!")
            return
        end

        local mentioned = message.mentionedUsers:first()
        if not mentioned then
            message.channel:reply("⚠️ Vui lòng tag thành viên cần mute! Ví dụ: `!mute @user`")
            return
        end

        message.channel:reply(string.format("🔇 Đã thực hiện lệnh mute thành công đối với %s", mentioned.username))

    elseif cmd == '!ban' then
        if not message.member:hasPermission('banMembers') then
            message.channel:reply("❌ Bạn không có quyền ban thành viên!")
            return
        end

        local mentioned = message.mentionedUsers:first()
        if not mentioned then
            message.channel:reply("⚠️ Vui lòng tag thành viên cần ban! Ví dụ: `!ban @user`")
            return
        end

        local success, err = guild:banUser(mentioned.id)
        if success then
            message.channel:reply(string.format("🔨 Đã ban thành công thành viên **%s** khỏi server.", mentioned.username))
        else
            message.channel:reply("❌ Không thể ban thành viên này (Bot có thể thiếu quyền).")
        end
    end
end)

client:run('Bot ' .. os.getenv('BOT_TOKEN'))
