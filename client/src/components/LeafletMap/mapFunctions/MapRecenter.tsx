import { useSelector } from "react-redux";
import { useMap } from "react-leaflet"

//Types
import { TinklRootState } from "../../../redux/types/TinklRootState";
import { useEffect } from "react";

export const MapRecenter: React.FC = () => {
    const map = useMap();
    const location = useSelector((state: TinklRootState) => state.user.location);

    useEffect(() => {
        if (location) {
            const { lat, lng } = location;
            map.setView([lat, lng], 15);
        }
    }, [map, location])

    return null;
}