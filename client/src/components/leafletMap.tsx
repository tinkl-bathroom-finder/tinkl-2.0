import { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { Icon } from 'leaflet';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import leaflet from 'leaflet';
import 'leaflet/dist/leaflet.css';
import blueDotIconFile from './blue_dot.png';
import toiletIconFile from './toilet-marker.png';
import { Button } from '@mui/material';
import { TinklRootState } from '../redux/types/TinklRootState';
import { BathroomType } from '../redux/types/BathroomType';

import MyLocationIcon from '@mui/icons-material/MyLocation';
import { MapLibreTileLayer } from './MapLibreTileLayer';



export const LeafletMap = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const options = useSelector((state: TinklRootState) => state.options);
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = options.darkMode ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json" : "https://tiles.stadiamaps.com/styles/outdoors.json"

    // const center = user.location.lat && user.location.lng ? [user.location.lat, user.location.lng] : [44.9560534624369, -93.16002444658359];

    const blueDotIcon = new Icon({
        iconUrl: blueDotIconFile,
        iconSize: [25, 25], // size of the icon
        iconAnchor: [5, 5], // point of the icon which will correspond to marker's location
        popupAnchor: [0, -5] // point from which the popup should open relative to the iconAnchor
    });

    const toiletIcon = new Icon({
        iconUrl: toiletIconFile,
        iconSize: [25, 25],
        iconAnchor: [5, 5],
        popupAnchor: [0, -5]
    });

    const RecenterButton: React.FC = () => {
        const map = useMap();
        const handleRecenter = () => {
            map.setView(user.location, map.getZoom());
        };
        return (<Button onClick={handleRecenter} style={{
            position: 'absolute',
            bottom: '20px',
            right: '5px',
            zIndex: 1000,
            backgroundColor: 'rgba(169, 62, 128, 0.3)',
        }}
        >
            <MyLocationIcon />
        </Button>
        )
    }


    return (
        <MapContainer center={user.location} zoom={13} style={{ height: "100%", width: "100%" }}>
            {/* <TileLayer
                url="https://tiles.stadiamaps.com/data/openmaptiles/{z}/{x}/{y}.pbf"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            /> */}

            {/* Dark Style Map */}
            <MapLibreTileLayer
                attribution='&copy; <a href="https://stadiamaps.com/" target="_blank">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
                url={mapTilesURL}
            />


            <RecenterButton />
            <Marker
                position={user.location}
                icon={blueDotIcon}
            >
                {bathroomData.map((item, index) => {
                    return (
                        <Marker
                            key={index}
                            position={[item.latitude, item.longitude]}
                            icon={toiletIcon}
                            alt={item.name}
                        >
                            <Popup>
                                <p>{item.name}</p>
                                <Button>Flag</Button>
                                <Button>Like</Button>

                            </Popup>
                        </Marker>
                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
