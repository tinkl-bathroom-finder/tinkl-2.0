import { createSlice } from "@reduxjs/toolkit";

//Type
import { TinklOptions } from "../types/TinklOptions";
import { PayloadAction } from "@reduxjs/toolkit";

const initialState: TinklOptions = {
    showLogin: false,
    showAbout: false,
    showUserProfile: false,
    showAddBathroom: false,
    showMainApp: true,
    mapView: true,
    darkMode: false,
}

const tinklOptionsSlice = createSlice({
    name: 'options',
    initialState: initialState,
    reducers: {
        toggleLoginScreen(state) {
            state.showLogin = !state.showLogin;
            state.showMainApp = !state.showMainApp;
        },
        toggleAboutScreen(state) {
            state.showAbout = !state.showAbout;
            // state.showMainApp = !state.showMainApp;
        },
        setAboutScreen(state, action: PayloadAction<boolean>) {
            state.showAbout = action.payload;
        },
        toggleUserProfile(state) {
            state.showUserProfile = !state.showUserProfile;
            state.showMainApp = !state.showMainApp;
        },
        toggleAddbathroom(state) {
            state.showAddBathroom = !state.showAddBathroom;
            state.showMainApp = !state.showMainApp;
        },
        toggleMapView(state) {
            state.mapView = !state.mapView;
        },
        showMainApp(state) {
            state.showLogin = false;
            state.showAbout = false;
            state.showUserProfile = false;
            state.showAddBathroom = false;
            state.showMainApp = true;
        },
        toggleDarkMode(state) {
            state.darkMode = !state.darkMode;
        }
    }
});

export const {
    toggleLoginScreen,
    toggleAboutScreen,
    setAboutScreen,
    toggleUserProfile,
    toggleAddbathroom,
    showMainApp,
    toggleMapView,
    toggleDarkMode
} = tinklOptionsSlice.actions;

export default tinklOptionsSlice.reducer;