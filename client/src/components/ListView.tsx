import React from "react";
import { useSelector } from "react-redux";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";

export const ListView: React.FC = () => {
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);

    return (
        <div className="listViewContainer">
            <ul>
                {bathroomData.map((place) => (
                    <li key={`${place.api_id}${place.name}`}>{place.name} - {place.city}</li>
                ))}
            </ul>
        </div>
    )
}