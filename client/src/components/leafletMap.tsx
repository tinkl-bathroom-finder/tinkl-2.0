// import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

//Map and Map Styling
import _, { Icon } from 'leaflet';
import { MapContainer, Marker, Popup, useMap } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-routing-machine/dist/leaflet-routing-machine.css';
import { MapLibreTileLayer } from './MapLibreTileLayer';
import blueDotIconFile from './blue_dot.png';
import toiletIconFile from './toilet-marker.png';

//Filter Actions
import {
    toggleOpen,
    togglePublic,
    toggleAccessible,
    toggleChangingTable,
    clearFilters
} from '../redux/reducers/bathroomFiltersReducer'

//MUI
import { Button } from '@mui/material';
import MyLocationIcon from '@mui/icons-material/MyLocation';
import {
    AccessibleForwardOutlined,
    BabyChangingStationOutlined,
    Man4,
    Public,
    TransgenderOutlined
  } from "@mui/icons-material";

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
    const dispatch = useDispatch()

    const user = useSelector((state: TinklRootState) => state.user);
    const options = useSelector((state: TinklRootState) => state.options);
    const filters = useSelector((state: TinklRootState) => state.filters);

    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = options.darkMode ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json" : "https://tiles.stadiamaps.com/styles/osm_bright.json"
    // const center = user.location.lat && user.location.lng ? [user.location.lat, user.location.lng] : [44.9560534624369, -93.16002444658359];

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
        popupAnchor: [0, -5],
    });

    const toiletIconClosed = new Icon({
        iconUrl: toiletIconFile,
        iconSize: [25, 25],
        iconAnchor: [5, 5],
        popupAnchor: [0, -5],
        className: 'toilet-icon-closed'
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

    const FilterOpenButton: React.FC = () => {
        const handleFilter = () => {
            dispatch(toggleOpen())
        };
        return (<Button onClick={handleFilter} style={{
            position: 'absolute',
            top: '10px',
            right: '10px',
            height: '32px',
            width: '101px',
            border: '2px solid grey',
            borderRadius: '1px',
            backgroundColor: !filters.open ? 'white' : 'gray',
            zIndex: 1000,
            textTransform: 'lowercase'
        }}
        >
            open now
        </Button>
        )
    };

    const FilterAccessibleButton: React.FC = () => {
        const handleFilter = () => {
            dispatch(toggleAccessible())
        };
        return (<Button onClick={handleFilter} style={{
            position: 'absolute',
            top: '41px',
            right: '76px',
            height: '32px',
            minWidth: '0px',
            width: '35px',
            padding: '0',
            border: '2px solid grey',
            borderRadius: '1px',
            backgroundColor: !filters.accessible ? 'white' : 'gray',
            zIndex: 1000,
        }}
        >
            <AccessibleForwardOutlined/>
        </Button>
        )
    };

    const FilterChangingButton: React.FC = () => {
        const handleFilter = () => {
            dispatch(toggleChangingTable())
        };
        return (<Button onClick={handleFilter} style={{
            position: 'absolute',
            top: '41px',
            right: '43px',
            height: '32px',
            minWidth: '0px',
            width: '35px',
            padding: '0',
            border: '2px solid grey',
            borderRadius: '1px',
            backgroundColor: !filters.changingTable ? 'white' : 'gray',
            zIndex: 1000,
        }}
        >
            <BabyChangingStationOutlined/>
        </Button>
        )
    };

    const FilterPublicButton: React.FC = () => {
        const handleFilter = () => {
            dispatch(togglePublic())
        };
        return (<Button onClick={handleFilter} style={{
            position: 'absolute',
            top: '41px',
            right: '10px',
            height: '32px',
            minWidth: '0px',
            width: '35px',
            padding: '0',
            border: '2px solid grey',
            borderRadius: '1px',
            backgroundColor: !filters.public ? 'white' : 'gray',
            zIndex: 1000,
        }}
        >
            <Public/>
        </Button>
        )
    };

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

            <RecenterButton />

            <FilterOpenButton />
            <FilterAccessibleButton />
            <FilterChangingButton />
            <FilterPublicButton />

            <Marker
                position={user.location}
                icon={blueDotIcon}
            >
                {bathroomData.map((item, index) => {
                    return (
                        // if no filters selected return all markers
                        !filters.open && !filters.accessible && !filters.changingTable && !filters.public &&
                        <Marker
                            key={index}
                            position={[item.latitude, item.longitude]}
                            icon={item.is_open ? toiletIcon : toiletIconClosed}
                            alt={item.name}
                        >
                            <Popup>
                                <p>{item.name}</p>
                                <p>{item.day_5_open} - {item.day_5_close}</p>
                                <Button>Flag</Button>
                                <Button>Like</Button>
                                <OpenInMapsButton address={item.street} />

                            </Popup>
                        </Marker>
                        // if open filter selec
                        || filters.open && item.is_open &&
                        <Marker
                            key={index}
                            position={[item.latitude, item.longitude]}
                            icon={item.is_open ? toiletIcon : toiletIconClosed}
                            alt={item.name}
                        >
                            <Popup>
                                <p>{item.name}</p>
                                <p>{item.day_5_open} - {item.day_5_close}</p>
                                <Button>Flag</Button>
                                <Button>Like</Button>
                                <OpenInMapsButton address={item.street} />

                            </Popup>
                        </Marker>
                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
