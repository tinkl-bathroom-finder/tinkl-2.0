import React, { useState } from "react";
import { useSelector } from "react-redux";
import Map, { Marker, NavigationControl, Popup } from 'react-map-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import { TinklRootState } from "../redux/types/TinklRootState";
import { BathroomType } from "../redux/types/BathroomType";

// import blueDotIconFile from './blue_dot.png';
// import toiletIconFile from './toilet-marker.png';

export const MapLibreMap: React.FC = () => {
    const [selectedBathroom, setSelectedBathroom] = useState<BathroomType | null>(null);
    const options = useSelector((state: TinklRootState) => state.options);
    const user = useSelector((state: TinklRootState) => state.user);
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = (
        options.darkMode
            ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json"
            : "https://tiles.stadiamaps.com/styles/osm_bright.json");

    const handleMarkerClick = (item: BathroomType) => {
        console.log(item);
        setSelectedBathroom(item);
    }


    return (
        <Map
            initialViewState={{
                longitude: user.location.lng,
                latitude: user.location.lat,
                zoom: 12,
            }}

            style={{ width: '100%' }}
            mapStyle={mapTilesURL}>
            <Marker longitude={user.location.lng} latitude={user.location.lat}>
                <img src="./blue_dot.png" alt="Location" style={{ width: '25px', height: '25px' }} />
            </Marker>
            {bathroomData.map((item, index) => (
                <Marker
                    // element={}
                    key={index}
                    longitude={item.longitude} latitude={item.latitude} anchor="bottom"
                    onClick={() => handleMarkerClick(item)}
                    style={{ cursor: 'pointer' }}
                >

                    <img
                        src="./toilet-marker.png"
                        alt="Marker"
                        style={{ width: '35px', height: '35px' }}
                    />
                </Marker>
            ))}

            {selectedBathroom && (
                <Popup
                    longitude={selectedBathroom.longitude}
                    latitude={selectedBathroom.latitude}
                    onClose={() => setSelectedBathroom(null)}
                    closeButton={true}
                    anchor="top"
                >
                    <div>
                        <h3>{selectedBathroom.name}</h3>
                        {/* Add more information here if needed */}
                    </div>
                </Popup>
            )}


            <NavigationControl position="top-left" />
            <img src="./blue_dot" alt="Location" style={{ width: '25px', height: '25px' }} />
        </Map>

    )




}