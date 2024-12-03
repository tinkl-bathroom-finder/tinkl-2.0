import { useState, } from "react";
import { useDispatch } from "react-redux";
import { useNavigate } from "react-router-dom";

import { Menu, MenuItem } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import { IconButton } from "@mui/material";

//Redux Actions
import { toggleAboutScreen } from "../redux/reducers/tinklOptionsReducer";

export const AppHamburgerMenu: React.FC = () => {

    const [anchorEl, setAncorEl] = useState<null | HTMLElement>(null);
    const dispatch = useDispatch();
    const navigate = useNavigate();

    const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAncorEl(event.currentTarget);
    }

    const handleMenuClose = () => {
        setAncorEl(null);
    }

    const handleAboutScreen = () => {
        setAncorEl(null);
        dispatch(toggleAboutScreen());
    }

    const handleListView = () => {
        setAncorEl(null);
        navigate("/listview");
    }

    const handleAddBathrom = () => {
        setAncorEl(null);
        navigate("/addbathroom");
    }

    const handleContact = () => {
        setAncorEl(null);
        navigate("/contact");
    }

    return (
        <div>
            <IconButton onClick={handleMenuOpen} sx={{color: '#080808'}}>
                <MenuIcon />
            </IconButton>
            <Menu
                anchorEl={anchorEl}
                open={Boolean(anchorEl)}
                onClose={handleMenuClose}
            >
                <MenuItem onClick={handleAboutScreen}>About</MenuItem>
                <MenuItem onClick={handleAddBathrom}>Add</MenuItem>
                <MenuItem onClick={handleListView}>List View</MenuItem>
                <MenuItem onClick={handleContact}>Contact Tinkl</MenuItem>

            </Menu>
        </div>

    );
}