import React from 'react';
import { useSelector, useDispatch } from 'react-redux';

//MUI
import { BottomNavigation, BottomNavigationAction } from "@mui/material";
import AddIcon from '@mui/icons-material/Add';
import ListIcon from '@mui/icons-material/List';
import MapIcon from '@mui/icons-material/Map';
import InfoIcon from '@mui/icons-material/Info';
import DarkModeIcon from '@mui/icons-material/DarkMode';
import LightModeIcon from '@mui/icons-material/LightMode';

//Types
import { TinklRootState } from '../redux/types/TinklRootState';

//Actions
import { toggleAboutScreen, toggleDarkMode, toggleMapView } from '../redux/reducers/tinklOptionsReducer';

export const BottomNav: React.FC = () => {

    const tinklOptions = useSelector((state: TinklRootState) => state.options);
    const dispatch = useDispatch();

    const handleAddBathroom = () => {
        console.log('Add Bathroom clicked');
    }

    const handleMapListView = () => {
        dispatch(toggleMapView());
    }

    const handleShowAbout = () => {
        dispatch(toggleAboutScreen());
    }

    const handleDarkLight = () => {
        dispatch(toggleDarkMode());
    }

    return (
        <>
            <BottomNavigation
                showLabels
                sx={{
                    justifyContent: 'center',
                    '& .MuiBottomNavigationAction-root': {
                        minWidth: 'auto', // Allows the buttons to be closer together
                        marginRight: '-8px', // Adjust this value to reduce the gap between buttons
                    },
                }}>

                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label="Add Bathroom"
                    icon={<AddIcon />}
                    onClick={handleAddBathroom}
                />
                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label={tinklOptions.mapView ? "List View" : "Map View"}
                    icon={tinklOptions.mapView ? <ListIcon /> : <MapIcon />}
                    onClick={handleMapListView}
                />

                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label="About Tinkl"
                    icon={<InfoIcon />}
                    onClick={handleShowAbout}
                />

                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label={tinklOptions.darkMode ? "Light" : "Dark"}
                    icon={tinklOptions.darkMode ? <LightModeIcon /> : <DarkModeIcon />}
                    onClick={handleDarkLight}
                />
            </BottomNavigation>
        </>
    )
}