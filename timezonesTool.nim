import sugar, sequtils, strutils, parseopt, json, times, os, options, terminal
import timezones

type
    TempDisplayTime = object
        display: string
        timezone: string

    TempConfig = object
        `timezones`: Option[seq[TempDisplayTime]]
        format: Option[string]
    
    DisplayTime = object
        display: string
        timezone: Timezone
    
    Config = object
        `timezones`: seq[DisplayTime]
        format: string

proc loadConfigFile(configPath: string): TempConfig =
    var f = readFile(configPath)
    var jsonConfig = f.parseJson()
    jsonConfig.to(TempConfig)

proc loadParamTimezone(values: seq[string]): TempConfig =
    var tempArr: seq[TempDisplayTime] = @[]
    for x in values:
        var aux: seq[string] = x.split(':')
        var newDisplayName = aux[0]
        var newTimezone = aux[1]
        var tempDisplayTime: TempDisplayTime = TempDisplayTime(display: newDisplayName, timezone: newTimezone)
        tempArr.add(tempDisplayTime)
    TempConfig(timezones: some(tempArr))

proc loadParamFormat(value: string): TempConfig =
    TempConfig(format: some(value))

proc combine(configs: seq[TempConfig]): TempConfig =
    result = TempConfig()
    for config in configs:
        if config.timezones.isSome():
            if result.timezones.isNone():
                result.timezones = config.timezones
            else:
                result.timezones = some(result.timezones.get() & config.timezones.get())
        if config.format.isSome():
            result.format = config.format

proc orDefault(tempConfig: TempConfig, default: Config): Config =
    result = default
    if tempConfig.timezones.isSome():
        var oldTimezones = tempConfig.timezones.get()
        var newTimezones: seq[DisplayTime] = @[]
        for oldTimezone in oldTimeZones:
            var aux = tz(oldTimezone.timezone)
            var newTimezone = DisplayTime(display: oldTimezone.display, timezone: aux)
            newTimezones.add(newTimezone)
        result.timezones = newTimezones
    if tempConfig.format.isSome():
        result.format = tempConfig.format.get()

proc showTimes(config: Config) =
    var names = config.timezones.map((x) => x.display)
    var nameLengths = names.map((x) => x.len)
    var maxNameLength = nameLengths.max()
    var printFormat = config.format
    var timeDifference = initDuration(seconds = 5)
    var padding = maxNameLength + 3
    eraseScreen()
    hideCursor()
    for i in 0..<len(config.timezones):
        var displayTime = config.timezones[i]
        displayTime.display = displayTime.display.alignLeft(maxNameLength)
        setCursorPos(0, i)
        writeStyled(displayTime.display, {styleBright})
    var currentTime = now()
    while true:
        if (now() - currentTime)  > timeDifference:
            for i in 0..<len(config.timezones):
                var displayTime = config.timezones[i]
                var aux = getTime().inZone(displayTime.timezone)
                setCursorPos(padding, i)
                echo aux.format(printFormat)

when isMainModule:
    var parameters = initOptParser(commandLineParams(), shortNoVal = {'a'}, longNoVal = @["second"])
    var configs: seq[TempConfig] = @[]
    for kind, key, val in parameters.getopt():
        case kind
        of cmdEnd: break
        of cmdShortOption, cmdLongOption:
            case key
            of "config", "c":
                if val != "": 
                    configs.add(loadConfigFile(val))
            of "timezones", "t":
                if val != "":
                    var newTimezones = val.split(' ')
                    configs.add(loadParamTimezone(newTimezones))
            of "format", "f": 
                if val != "":
                    configs.add(loadParamFormat(val))
            else: discard
        else: discard

    var defaultDisplayTime = DisplayTime(display: "local", timezone: tz("America/Argentina/Buenos_Aires"))
    var defaultTimezones: seq[DisplayTime] = @[defaultDisplayTime]
    var defaultConfig: Config = Config(`timezones`: defaultTimezones, format: "H:mm:ss")
    
    var usedConfig = configs.combine.orDefault(defaultConfig)
    showTimes(usedConfig)