// Function to get the user's local time in ISO 8601 format
export const getLocalISOTime = () => {
    const localDate = new Date();
    const localISOTime = new Date(localDate.getTime() - localDate.getTimezoneOffset() * 60000)
        .toISOString()
        .slice(0, 19); // Removing milliseconds
    return localISOTime;
};