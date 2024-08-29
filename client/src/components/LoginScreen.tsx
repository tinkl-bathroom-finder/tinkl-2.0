import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { TinklLogo } from './tinklLogo';
import { TextField } from '@mui/material';

export const LoginScreen: React.FC = () => {
    return (
        <div className="loginContainer">
            <div className='loginHeader'>
                <div className='logoBox'>
                    <TinklLogo width={120} height={120} />
                </div>
                <div className='logoHeaderText'>
                    <h1>tinkl</h1>
                    <h2>Pee in peace</h2>
                </div>
            </div>
            <div className='loginInputContainer'>
                <TextField
                    variant='outlined'
                    required
                    label="Username"
                    sx={{
                        marginBottom: '1.5rem'
                    }}
                />
                <TextField
                    variant='outlined'
                    required
                    label="Password"
                    type='password'
                />
            </div>

        </div>
    )
}