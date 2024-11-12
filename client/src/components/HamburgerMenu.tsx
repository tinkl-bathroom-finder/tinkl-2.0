import * as React from "react";
import { useState, } from "react";

import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import List from '@mui/material/List';
import Divider from '@mui/material/Divider';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import MenuItem from '@mui/material/MenuItem';
import Menu from '@mui/material/Menu';


export default function AppHamburgerMenu() {

    const [open, setOpen] = useState(false);

    const toggleDrawer = (newOpen: boolean) => () => {
        setOpen(newOpen);
    }

    const DrawerList = (
        <Box sx={{ width: 250 }}
            role='presentation'
            onClick={toggleDrawer(false)}
        >
            <List>
                {['Find a bathroom', 'About', 'Add', 'List View', 'Contact Us']}

            </List>
        </Box>
    )

    return (
        <div>
            <Button
                id='Menu Button'
                aria-controls={open ? 'menu' : undefined}
                aria-haspopup='true'
                aria-expanded={open ? 'true' : undefined}
                onClick={handleClick}
            >

            </Button>

        </div>
    )
}