import React from 'react';
import { AppHamburgerMenu } from './AppHamburgerMenu';
import { UserMenu } from './UserMenu';
import { useNavigate } from 'react-router-dom';

export const HeaderNav: React.FC = () => {
    const navigate = useNavigate();
  
    const handleShowMainApp = () => {
      navigate("/");
    }
    return (
        <div className="headerContainer">
        <AppHamburgerMenu />
        <a onClick={handleShowMainApp}>
          <header className="header">tinkl</header>
        </a>
        <UserMenu />
      </div>
    )
}