import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { BottomNavigation, BottomNavigationAction } from "@mui/material";
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
        <div>
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
                    onClick={handleAddBathroom}
                />
                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label={tinklOptions.mapView ? "List View" : "Map View"}
                    onClick={handleAddBathroom}
                />

                <BottomNavigationAction
                    style={{ color: 'black' }}
                    label="About Tinkl"
                    onClick={handleShowAbout}
                />
            </BottomNavigation>
        </div>
    )
}