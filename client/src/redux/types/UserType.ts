export interface UserType {
    id: number,
    username: string,
    location: LocationType,
    userTime: TimeType
}

export interface TimeType {
    day: number,
    hours: number,
}

export interface LocationType {
    lat: number,
    lng: number
}