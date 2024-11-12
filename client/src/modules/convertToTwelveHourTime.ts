export const convertToTwelveHourTime = (time: number | null) => {
    if (time !== null) {
        let twelveHourTime = time / 100
        let amOrPm = "am"
        if (time >= 1200) {
            if (twelveHourTime - 12 === 0) {
                twelveHourTime = 12
            } else {
                twelveHourTime = twelveHourTime - 12;
            }
            amOrPm = "pm"
        } else if (time === 2400 || time === 0) {
            twelveHourTime = 12;
            amOrPm = "am"
        }
        return `${twelveHourTime}${amOrPm}`
    }
}