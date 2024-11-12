export const convertToTwelveHourTime = (time: number | null) => {
    if (time !== null) {
        let twelveHourTime = time / 100
        let amOrPm = "am"
        if (time > 1200) {
            twelveHourTime = twelveHourTime - 12
            amOrPm = "pm"

        }
        return `${twelveHourTime}${amOrPm}`
    }
}