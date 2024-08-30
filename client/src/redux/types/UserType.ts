export interface UserType {
    id: number,
    username: string,
    location: LocationType
}

export interface LocationType {
    lat: number,
    lng: number
}