import { useSelector } from "react-redux";
import { useMap } from "react-leaflet"

//Types
import { TinklRootState } from "../../../redux/types/TinklRootState";
import { useEffect } from "react";

//Function to recent the primary map on the users location

export const MapRecenter: React.FC = () => {
    const map = useMap();
    const location = useSelector((state: TinklRootState) => state.user.location);
    const searchedLocation = useSelector((state: TinklRootState) => state.searchedLocation)

    useEffect(() => {
        if (searchedLocation.lat !== 0 && searchedLocation.lng !== 0) {
            const { lat, lng } = searchedLocation;
            map.setView([lat, lng], 15);
        }
        else if (location) {
            const { lat, lng } = location;
            map.setView([lat, lng], 15);
        }
    }, [map, location, searchedLocation])

    return null;
}