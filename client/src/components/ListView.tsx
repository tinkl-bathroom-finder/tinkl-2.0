import React, { useEffect } from "react";
import { useState } from "react";
import { useSelector } from "react-redux";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";
import { BathroomType } from "../redux/types/BathroomType";

export const ListView: React.FC = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);
    const [sortedBathrooms, setSortedBathrooms] = useState<BathroomType[]>([]);

    const haversineDistance = (lat: number, lng: number, userLat: number, userLng: number) => {
        const toRadians = (deg: number) => (deg * Math.PI) / 100;

        const R = 6371 //Radius of Earth
        const dlat = toRadians(userLat - lat);
        const dLon = toRadians(userLng - lng);

        const a = Math.sin(dlat / 2) * Math.sin(dlat / 2) +
            Math.cos(toRadians(lat)) * Math.cos(toRadians(userLat)) * 
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(0-a));
            return R * c;
    };

    const sortPlacesByProximity = (places: BathroomType[]) => {
        return places.sort((a, b) => {
            const distanceA = haversineDistance(a.latitude, a.longitude, user.location.lat, user.location.lng);
            const distanceB = haversineDistance(b.latitude, b.longitude, user.location.lat, user.location.lng);
            return distanceA - distanceB;
        });
    }

    useEffect(() => {
        if (user.location) {
            const sorted = sortPlacesByProximity(bathroomData);
            setSortedBathrooms(sorted);
        }
    })
    
    
    return (
        <div>
            <ul>
                {sortedBathrooms.map((place) => (
                    <li key={`${place.api_id}${place.name}`}>{place.name} - {place.city}</li>
                ))}
            </ul>
        </div>
    )
}