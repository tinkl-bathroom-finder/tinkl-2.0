// formats inserted_at timestamp as readable string
export const stringifyDate = (timestamp: Date) => {
    const date = new Date(timestamp);
    const options: Intl.DateTimeFormatOptions = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", options);
    return stringifiedDate;
};