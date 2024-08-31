import React from 'react';
import { useSelector } from 'react-redux';

//MUI
import { BottomNavigation, BottomNavigationAction } from "@mui/material";
import AddIcon from '@mui/icons-material/Add';
import ListIcon from '@mui/icons-material/List';
import MapIcon from '@mui/icons-material/Map';
import InfoIcon from '@mui/icons-material/Info';

//Types
import { TinklRootState } from '../redux/types/TinklRootState';

export const BottomNav: React.FC = () => {

    const tinklOptions = useSelector((state: TinklRootState) => state.options);

    const handleAddBathroom = () => {
        console.log('Add Bathroom clicked');
    }

    const handleShowAbout = () => {
        console.log('Show About modal');
    }


    return (
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
                onClick={handleAddBathroom}
            />

            <BottomNavigationAction
                style={{ color: 'black' }}
                label="About Tinkl"
                icon={<InfoIcon />}
                onClick={handleShowAbout}
            />
        </BottomNavigation>
    )
}