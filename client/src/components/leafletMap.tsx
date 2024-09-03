// import { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';

//Map and Map Styling
import _, { Icon } from 'leaflet';
import { MapContainer, Marker, Popup, useMap } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-routing-machine/dist/leaflet-routing-machine.css';
import { MapLibreTileLayer } from './MapLibreTileLayer';
import blueDotIconFile from './blue_dot.png';
import toiletIconFile from './toilet-marker.png';

//MUI
import { Button } from '@mui/material';
import MyLocationIcon from '@mui/icons-material/MyLocation';

//Types
import { TinklRootState } from '../redux/types/TinklRootState';
import { BathroomType } from '../redux/types/BathroomType';

//Components
import { OpenInMapsButton } from './OpenInMapsButton';


// const RoutingControl = ({ waypoints }: { waypoints: L.LatLngExpression[] }) => {
//     const map = useMap();

//     useEffect(() => {
//         // Initialize routing control
//         const routingControl = L.Routing.control({
//             waypoints: waypoints.map(([lat, lng]) => L.latLng(lat, lng)),
//             routeWhileDragging: true,
//             router: L.Routing.osrmv1({
//                 serviceUrl: 'https://router.project-osrm.org/route/v1' // OSRM service URL
//             })
//         }).addTo(map);

//         // Cleanup on unmount
//         return () => {
//             map.removeControl(routingControl);
//         };
//     }, [map, waypoints]);

//     return null;
// };

export const LeafletMap = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const options = useSelector((state: TinklRootState) => state.options);
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = options.darkMode ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json" : "https://tiles.stadiamaps.com/styles/osm_bright.json"
    // const center = user.location.lat && user.location.lng ? [user.location.lat, user.location.lng] : [44.9560534624369, -93.16002444658359];

    //Getting current time
    const now = new Date();


    // const [waypoints, setWaypoints] = useState<L.LatLngExpression[]>([
    //     user.location,  // Start location
    //     [51.515, -0.1]  // Default destination location
    // ]);

    // const setDestination = (lat: number, lng: number) => {
    //     setWaypoints([user.location, [lat, lng]]);
    // };

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
    };

    const checkHours = (open: string, close: string) => {
        const currentTime = now.getHours() * 60 + now.getMinutes();
    }

    return (
        <MapContainer center={user.location} zoom={13} style={{ height: "100%", width: "100%" }}>

            {/* Generic open street map tile set */}
            {/* <TileLayer
                url="https://tiles.stadiamaps.com/data/openmaptiles/{z}/{x}/{y}.pbf"
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            /> */}

            {/* Styled open street map using Stadia preset and MapLibre */}
            <MapLibreTileLayer
                attribution='&copy; <a href="https://stadiamaps.com/" target="_blank">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
                url={mapTilesURL}
            />

            {/* <RoutingControl waypoints={waypoints} /> */}
            <RecenterButton />
            <Marker
                position={user.location}
                icon={blueDotIcon}
            >
                {bathroomData.map((item, index) => {
                    // let isOpen: boolean = false;
                    // switch (now.getDay()) {
                    //     case 0: isOpen = checkHours(item.day_0_close, item.day_0_close); break;
                    // }
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
                                <OpenInMapsButton address={item.street} />
                                {/* <Button onClick={() => setDestination(item.latitude, item.longitude)}>Nav</Button> */}

                            </Popup>
                        </Marker>
                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
