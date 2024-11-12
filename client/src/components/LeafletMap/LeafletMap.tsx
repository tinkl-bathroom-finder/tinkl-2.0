import { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';

//Map and Map Styling
import { MapContainer, Marker, useMap } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-routing-machine/dist/leaflet-routing-machine.css';
import { MapLibreTileLayer } from './mapFunctions/MapLibreTileLayer.ts';
import { MapRecenter } from './mapFunctions/MapRecenter.tsx';
import { filterBathroomData } from '../../modules/filterBathroomData.ts';

//Redux Filter Actions
import {
    FilterOpenButton,
    FilterAccessibleButton,
    FilterChangingButton,
    FilterPublicButton
} from './mapFunctions/MapFilterButtons.tsx';

//MUI
import { Button } from '@mui/material';
import MyLocationIcon from '@mui/icons-material/MyLocation';

//Types
import { TinklRootState } from '../../redux/types/TinklRootState.ts';
import { BathroomType } from '../../redux/types/BathroomType.ts';

//Components
import { MapInfoWindow } from './InfoWindow/PopupWindow.tsx';
import { blueDotIcon, toiletIcon, toiletIconClosed } from './mapFunctions/MapIcons.tsx';

export const LeafletMap = () => {

    const user = useSelector((state: TinklRootState) => state.user);
    const options = useSelector((state: TinklRootState) => state.options);
    const filters = useSelector((state: TinklRootState) => state.filters);
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);

    const [filteredBathroomData, setFilteredBathroomData] = useState<BathroomType[]>(bathroomData);

    const mapTilesURL = options.darkMode ? "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json" : "https://tiles.stadiamaps.com/styles/osm_bright.json"



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

    useEffect(() => {
        setFilteredBathroomData(() => filterBathroomData(bathroomData, filters));
    }, [filters, filteredBathroomData, bathroomData])

    return (
        <MapContainer center={user.location} zoom={15} style={{ height: "75%", width: "90%", textAlign: 'center', borderRadius: '5px' }}>

            {/* Styled open street map using Stadia preset and MapLibre */}
            <MapLibreTileLayer
                attribution='&copy; <a href="https://stadiamaps.com/" target="_blank">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
                url={mapTilesURL}
            />
            <MapRecenter />
            <RecenterButton />

            <FilterOpenButton />
            <FilterAccessibleButton />
            <FilterChangingButton />
            <FilterPublicButton />

            <Marker
                position={user.location}
                icon={blueDotIcon}
            >
                {filteredBathroomData.map((bathroom, index) => {
                    return (
                        <Marker
                            key={index}
                            position={[bathroom.latitude, bathroom.longitude]}
                            icon={bathroom.is_open ? toiletIcon : toiletIconClosed}
                            alt={bathroom.name}
                        >
                            <MapInfoWindow bathroom={bathroom} />
                        </Marker>


                    )
                })
                }
            </Marker>
        </MapContainer>
    );
};
