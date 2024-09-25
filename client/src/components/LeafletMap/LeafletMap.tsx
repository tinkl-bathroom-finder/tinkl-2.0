import { useDispatch, useSelector } from 'react-redux';

//Map and Map Styling
import _, { Icon } from 'leaflet';
import { MapContainer, Marker, useMap } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-routing-machine/dist/leaflet-routing-machine.css';
import { MapLibreTileLayer } from './MapLibreTileLayer.ts';
import blueDotIconFile from './blue_dot.png';
import toiletIconFile from './toilet-marker.png';

//Redux Filter Actions
import {
    toggleOpen,
    togglePublic,
    toggleAccessible,
    toggleChangingTable,
    clearFilters,
} from '../../redux/reducers/bathroomFiltersReducer.ts'

//MUI
import { Button } from '@mui/material';
import MyLocationIcon from '@mui/icons-material/MyLocation';
import {
    AccessibleForwardOutlined,
    BabyChangingStationOutlined,
    // Man4,
    Public,
    // TransgenderOutlined
} from "@mui/icons-material";

//Types
import { TinklRootState } from '../../redux/types/TinklRootState.ts';
import { BathroomType } from '../../redux/types/BathroomType.ts';

//Components
// import { OpenInMapsButton } from './OpenInMapsButton.tsx';
import { PopupWindow } from "./PopupWindow.tsx"

export const LeafletMap = () => {
    const dispatch = useDispatch()

    const user = useSelector((state: TinklRootState) => state.user);
    const options = useSelector((state: TinklRootState) => state.options);
    const filters = useSelector((state: TinklRootState) => state.filters);
    // const mapBox = useMap();
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    const mapTilesURL = options.darkMode ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json" : "https://tiles.stadiamaps.com/styles/osm_bright.json"

    const blueDotIcon = new Icon({
        iconUrl: blueDotIconFile,
        iconSize: [25, 25], // size of the icon
        iconAnchor: [5, 5], // point of the icon which will correspond to marker's location
        popupAnchor: [0, -5] // point from which the popup should open relative to the iconAnchor
    });

    const toiletIcon = new Icon({
        iconUrl: toiletIconFile,
        iconSize: [60, 60],
        iconAnchor: [20, 60],
        popupAnchor: [0, 0],
    });

    const toiletIconClosed = new Icon({
        iconUrl: toiletIconFile,
        iconSize: [60, 60],
        iconAnchor: [5, 5],
        popupAnchor: [0, 0],
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
            if (!filters.open) { dispatch(clearFilters()) }
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
            if (!filters.accessible) { dispatch(clearFilters()) }
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
            <AccessibleForwardOutlined />
        </Button>
        )
    };

    const FilterChangingButton: React.FC = () => {
        const handleFilter = () => {
            if (!filters.changingTable) { dispatch(clearFilters()) }
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
            <BabyChangingStationOutlined />
        </Button>
        )
    };

    const FilterPublicButton: React.FC = () => {
        const handleFilter = () => {
            if (!filters.public) { dispatch(clearFilters()) }
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
            <Public />
        </Button>
        )
    };


    return (
        <MapContainer center={user.location} zoom={15} style={{ height: "75%", width: "90%", textAlign: 'center', borderRadius: '5px' }}>

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
                {/* !!! ATROCIOUS CODE INCOMING !!! */}
                {bathroomData.map((bathroom, index) => {
                    return (
                        // if no filters selected return all markers
                        !filters.open && !filters.accessible && !filters.changingTable && !filters.public &&
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <PopupWindow bathroom={bathroom} />
                        </Marker>

                        // single filters
                        || filters.accessible && bathroom.accessible &&
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <PopupWindow bathroom={bathroom} />
                        </Marker>
                        || filters.changingTable && bathroom.changing_table &&
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <PopupWindow bathroom={bathroom} />
                        </Marker>
                        || filters.open && bathroom.is_open &&
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <PopupWindow bathroom={bathroom} />
                        </Marker>
                        || filters.public && bathroom.public &&
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <PopupWindow bathroom={bathroom} />
                        </Marker>
                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
