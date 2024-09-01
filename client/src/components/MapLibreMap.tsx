import React from "react";
import { useSelector } from "react-redux";
import Map, { Marker, NavigationControl } from 'react-map-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import { TinklRootState } from "../redux/types/TinklRootState";


export const MapLibreMap: React.FC = () => {
    const options = useSelector((state: TinklRootState) => state.options);
    const user = useSelector((state: TinklRootState) => state.user);
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = (
        options.darkMode
            ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json"
            : "https://tiles.stadiamaps.com/styles/osm_bright.json");

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
                <Marker key={index} longitude={item.longitude} latitude={item.latitude} anchor="bottom">
                    <img
                        src="./toilet-marker.png"
                        alt="Marker"
                        style={{ width: '25px', height: '25px' }}
                    />
                </Marker>
            ))
            }
            <NavigationControl position="top-left" />
            <img src="./blue_dot" alt="Location" style={{ width: '25px', height: '25px' }} />
        </Map>

    )




}